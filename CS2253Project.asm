.data
nsRedDuration:    .word 10  # North-South red light duration
nsGreenDuration:   .word 7   # North-South green light duration
nsYellowDuration:  .word 3   # North-South yellow light duration
ewRedDuration:    .word 10  # East-West red light duration
ewGreenDuration:   .word 7   # East-West green light duration
ewYellowDuration:  .word 3   # East-West yellow light duration

init_msg:        .asciiz "Traffic light simulation started. Press any key to continue...\n"
ns_red_msg:      .asciiz "North-South Red light is ON\n"
ns_green_msg:    .asciiz "North-South Green light is ON\n"
ns_yellow_msg:   .asciiz "North-South Yellow light is ON\n"
ew_red_msg:      .asciiz "East-West Red light is ON\n"
ew_green_msg:    .asciiz "East-West Green light is ON\n"
ew_yellow_msg:   .asciiz "East-West Yellow light is ON\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, init_msg
    syscall

    # Start the traffic cycle.
    jal traffic_cycle

traffic_cycle:
    # Handle the sequence for traffic lights with delays and messages
    li $v0, 4
    la $a0, ns_green_msg
    syscall
    la $a0, nsGreenDuration
    jal delay

    li $v0, 4
    la $a0, ew_red_msg
    syscall
    la $a0, ewRedDuration
    jal delay

    li $v0, 4
    la $a0, ns_yellow_msg
    syscall
    la $a0, nsYellowDuration
    jal delay

    li $v0, 4
    la $a0, ns_red_msg
    syscall
    la $a0, nsRedDuration
    jal delay

    li $v0, 4
    la $a0, ew_green_msg
    syscall
    la $a0, ewGreenDuration
    jal delay

    li $v0, 4
    la $a0, ew_yellow_msg
    syscall
    la $a0, ewYellowDuration
    jal delay

    # Loop back to start of the traffic cycle
    j traffic_cycle

delay:
    lw $t0, 0($a0)    # Load the duration from the memory
    sll $t0, $t0, 22  # Scale the duration for the delay to make it longer

delay_loop:
    addi $t0, $t0, -1  # Decrement the delay counter
    bgtz $t0, delay_loop  # Continue looping until zero
    jr $ra  # Return from delay
