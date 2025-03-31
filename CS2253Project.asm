.data
nsRedDuration:    .word 3   # Reduced for presentation
nsGreenDuration:   .word 3
nsYellowDuration:  .word 2
ewRedDuration:    .word 3
ewGreenDuration:   .word 3
ewYellowDuration:  .word 2

# Soufiane – Task 4 data starts here #############################
pedestrian_message:   .asciiz "Simulate pedestrian button press (0=No, 1=Yes): "
pedestrian_notice: .asciiz "Pedestrian button pressed – wait for safe crossing\n"
pedestrian_signal:.asciiz "Pedestrian crossing allowed now\n"
pedestrian_duration: .word 2      # Reduced for presentation
# Soufiane – Task 4 data ends here ###############################

# Countdown visual display components
time_left_prefix: .asciiz "Time left: "
secondes_msg:     .asciiz " secondes "
main_ascii:       .asciiz "[*]\n"

init_display:        .asciiz "Traffic light simulation started.\n"
ns_speed_label: .asciiz "Enter North-South speed limit (km/h): "
ew_speed_label: .asciiz "Enter East-West speed limit (km/h): "
ns_red_display:      .asciiz "North-South Red light is ON\n"
ns_green_display:    .asciiz "North-South Green light is ON\n"
ns_yellow_display:   .asciiz "North-South Yellow light is ON\n"
ew_red_display:     .asciiz "East-West Red light is ON\n"
ew_green_display:   .asciiz "East-West Green light is ON\n"
ew_yellow_display:  .asciiz "East-West Yellow light is ON\n"

# Soufiane - Feature 2 data (Statistics)
cycle_count:       .word 0
pedestrian_count:  .word 0
total_speed:       .word 0
simulation_end_display:.asciiz "Traffic Simulation Ended\n"
total_cycles_display:  .asciiz "Total cycles: "
pedestrian_total_display:    .asciiz "Pedestrian crossings: "
average_speed_display: .asciiz "Average speed entered: "
kmh_msg:           .asciiz " km/h\n"

.text
.globl main

main:

    li $v0, 4
    la $a0, init_display
    syscall

# ------------------ Task 3: Safety Feature (Soufiane) ------------------
# Ask user to enter North-South and East-West speed limits.
# Then calculate yellow light duration = speed / 10 (integer division).
# This ensures enough time to stop safely depending on road speed.

    li $v0, 4
    la $a0, ns_speed_label
    syscall
    li $v0, 5
    syscall
    li $t1, 10
    div $v0, $t1
    mflo $t0
    sw $t0, nsYellowDuration
    move $t3, $v0

    li $v0, 4
    la $a0, ew_speed_label
    syscall
    li $v0, 5
    syscall
    li $t1, 10
    div $v0, $t1
    mflo $t0
    sw $t0, ewYellowDuration
    move $t4, $v0
    add $t5, $t3, $t4
    sw $t5, total_speed
    
    # ----------------------------------------------------------------------
    jal traffic_cycle

traffic_cycle:
    li $v0, 4
    la $a0, ns_green_display
    syscall
    la $a0, nsGreenDuration
    jal delay

    li $v0, 4
    la $a0, ew_red_display
    syscall
    la $a0, ewRedDuration
    jal delay

    li $v0, 4
    la $a0, ns_yellow_display
    syscall
    la $a0, nsYellowDuration
    jal delay

    li $v0, 4
    la $a0, ns_red_display
    syscall
    la $a0, nsRedDuration
    jal delay

    li $v0, 4
    la $a0, ew_green_display
    syscall
    la $a0, ewGreenDuration
    jal delay

    li $v0, 4
    la $a0, ew_yellow_display
    syscall
    la $a0, ewYellowDuration
    jal delay

    # ------------------ Task 4: Pedestrian Button (Soufiane) ----------------
    # After each full cycle, prompt the user to simulate pedestrian button.
    # If input is 1 → allow pedestrian crossing.
    # Add a delay to simulate pedestrian crossing time.
    # Count the number of times pedestrians crossed (for statistics).

    li $v0, 4
    la $a0, pedestrian_message
    syscall
    li $v0, 5
    syscall
    beq $v0, 1, handle_pedestrian
    j continue_cycle

handle_pedestrian:
    lw $t0, pedestrian_count
    addi $t0, $t0, 1
    sw $t0, pedestrian_count

    li $v0, 4
    la $a0, pedestrian_notice
    syscall
    li $v0, 4
    la $a0, pedestrian_signal
    syscall

    la $a0, pedestrian_duration
    jal delay
    # -----------------------------------------------------------------------

continue_cycle:
    lw $t1, cycle_count
    addi $t1, $t1, 1
    sw $t1, cycle_count
    li $t2, 2
    beq $t1, $t2, end_simulation
    j traffic_cycle

# ------------------ Feature 1: Visual Countdown (Soufiane) --------------
# During each light phase, show a dynamic countdown like:
# "Time left: 3 secondes [*]"
# This enhances user experience and mimics a real-world display.
# -----------------------------------------------------------------------
delay:
    lw $t1, 0($a0)
    move $t2, $t1

delay_outer:
    blez $t2, delay_end

    li $v0, 4
    la $a0, time_left_prefix
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 4
    la $a0, secondes_msg
    syscall

    li $v0, 4
    la $a0, main_ascii
    syscall

    li $t3, 1
    sll $t3, $t3, 21

delay_inner:
    addi $t3, $t3, -1
    bgtz $t3, delay_inner

    addi $t2, $t2, -1
    j delay_outer

delay_end:
    jr $ra

# ------------------ Feature 2: Statistics Summary (Soufiane) ------------
# After 5 cycles, show a final report:
# - Total cycles completed
# - Total pedestrian crossings
# - Average speed entered (km/h)
# This summary helps track how the simulation performed overall.
# ------------------------------------------------------------------------
end_simulation:
    li $v0, 4
    la $a0, simulation_end_display
    syscall

    li $v0, 4
    la $a0, total_cycles_display
    syscall
    lw $a0, cycle_count
    li $v0, 1
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall

    li $v0, 4
    la $a0, pedestrian_total_display
    syscall
    lw $a0, pedestrian_count
    li $v0, 1
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall

    li $v0, 4
    la $a0, average_speed_display
    syscall
    lw $t0, total_speed
    li $t1, 2
    div $t0, $t1
    mflo $a0
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, kmh_msg
    syscall

    li $v0, 10
    syscall
