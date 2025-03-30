 # User input section - Start
    li $v0, 4
    la $a0, change_duration_prompt
    syscall
    li $v0, 5
    syscall
    beqz $v0, skip_duration_change
    
    li $v0, 4
    la $a0, enter_ns_red
    syscall
    li $v0, 5
    syscall
    sw $v0, nsRedDuration

    li $v0, 4
    la $a0, enter_ns_green
    syscall
    li $v0, 5
    syscall
    sw $v0, nsGreenDuration
    
    li $v0, 4
    la $a0, enter_ns_yellow
    syscall
    li $v0, 5
    syscall
    sw $v0, nsYellowDuration
    
    li $v0, 4
    la $a0, enter_ew_red
    syscall
    li $v0, 5
    syscall
    sw $v0, ewRedDuration
    
    li $v0, 4
    la $a0, enter_ew_green
    syscall
    li $v0, 5
    syscall
    sw $v0, ewGreenDuration
    
    li $v0, 4
    la $a0, enter_ew_yellow
    syscall
    li $v0, 5
    syscall
    sw $v0, ewYellowDuration
    # User input section - End