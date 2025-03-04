.model small
.stack 100h

.data
    votes db 0, 0, 0    
    voteMsg db 'Voting Process:$'
    candidateMsg db 'Enter your vote (1-3) or 0 to display results: $'
    resultMsg db 'Votes for Candidate 1: $'
    newline db 0Dh, 0Ah, '$'
    result0Msg db 'Results:$'
    result2Msg db 'Votes for Candidate 2: $'
    result3Msg db 'Votes for Candidate 3: $'
    winnerMsg db 'Winner: Candidate $'
    tieMsg db 'All candidates have equal votes!$'
    tie2Msg db 'There is a tie between: $'
    invalidMsg db 'Invalid vote. Please enter a number between 0 and 3.$'
    msgEnd db 0Dh, 0Ah, '$'
    tie1and3 db ', 3$', '$'  
    tie1and2 db ', 2$', '$'  
    tie2and3 db ', 3$'

.code
main proc
    mov ax, @data
    mov ds, ax
    
    lea dx, voteMsg
    mov ah, 09h
    int 21h       
    
    lea dx, newline
    mov ah, 09h
    int 21h

voting_loop:
    lea dx, candidateMsg
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'          
    mov cl, al           

    cmp cl, 0
    je display_results
    cmp cl, 3
    ja invalid_vote

    mov bl, cl          
    dec bl              

    lea si, votes       
    mov al, [si + bx] 
    inc al
    mov [si + bx], al

    lea dx, msgEnd
    mov ah, 09h
    int 21h
    jmp voting_loop

invalid_vote: 
    lea dx, newline
    mov ah, 09h
    int 21h
    
    lea dx, invalidMsg
    mov ah, 09h
    int 21h
    lea dx, msgEnd
    mov ah, 09h
    int 21h
    jmp voting_loop

display_results:
    lea dx, newline
    mov ah, 09h
    int 21h
  
    lea dx, result0Msg
    mov ah, 09h
    int 21h     
     
    lea dx, newline
    mov ah, 09h
    int 21h
             
    lea dx, resultMsg
    mov ah, 09h
    int 21h

    mov al, votes[0]
    call PrintNumber

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, result2Msg
    mov ah, 09h
    int 21h

    mov al, votes[1]
    call PrintNumber

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, result3Msg
    mov ah, 09h
    int 21h

    mov al, votes[2]
    call PrintNumber

    lea dx, newline
    mov ah, 09h
    int 21h

    mov al, votes[0]
    mov bl, votes[1]
    cmp al, bl
    jne check_candidate2

    mov bl, votes[2]
    cmp al, bl
    jne check_candidate2

    lea dx, tieMsg
    mov ah, 09h
    int 21h
    jmp done

check_candidate2:
    mov al, votes[0]
    mov bl, votes[1]
    cmp al, bl
    jne check_candidate3

    mov bl, votes[2]
    cmp al, bl
    jg declare_tie_12

check_candidate3:
    mov al, votes[1]
    mov bl, votes[2]
    cmp al, bl
    jne declare_winner

    mov al, votes[0]
    cmp al, bl
    jg declare_tie_23

declare_tie_13:
    lea dx, tie2Msg
    mov ah, 09h
    int 21h

    mov dl, '1'
    mov ah, 02h
    int 21h

    lea dx, tie1and3
    mov ah, 09h
    int 21h
    jmp done

declare_tie_12:
    lea dx, tie2Msg
    mov ah, 09h
    int 21h

    mov dl, '1'
    mov ah, 02h
    int 21h

    lea dx, tie1and2
    mov ah, 09h
    int 21h
    jmp done

declare_tie_23:
    lea dx, tie2Msg
    mov ah, 09h
    int 21h

    mov dl, '2'
    mov ah, 02h
    int 21h

    lea dx, tie2and3
    mov ah, 09h
    int 21h
    jmp done

declare_winner:
    lea dx, winnerMsg
    mov ah, 09h
    int 21h

    mov bl, 0
    lea si, votes
    mov al, [si] 
    cmp al, [si + 1]
    jg first_candidate

second_candidate:
    mov al, [si + 1]
    cmp al, [si + 2]
    jg third_candidate
    jmp done

first_candidate:
    add bl, 1
    jmp print_winner

third_candidate:
    add bl, 2
    jmp print_winner

print_winner:
    add bl, '0'
    mov dl, bl
    mov ah, 02h
    int 21h

done:
    mov ah, 4Ch
    int 21h

PrintNumber proc
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    ret
PrintNumber endp

end main
