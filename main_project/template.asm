;Student: Alireza Mirrokni (student number: 401106617)
;Instructor: Prof. Jahangir
;Sharif University Of Technology
;Winter 2024
;Description: this is an assembly program to do matrix multiplication and calculate matrix convolution

%include "asm_io.inc"

section .data
    ;VARIABLES
    ;defining the variables needed for saving values
    matrix1: times 10000 dd 0
    matrix2: times 10000 dd 0
    temp_matrix1: times 10000 dd 0
    temp_matrix2_transpose: times 10000 dd 0
    matrix2_transpose: times 10000 dd 0
    sum: dd 0.0
    sum_packed: dd 0.0
    product_matrix: times 10000 dd 0
    temp_product_matrix: times 10000 dd 0
    product_matrix_packed: times 10000 dd 0
    n: dq 1
    k: dq 1
    m: dq 1
    number_of_matrix1_entries: dq 0
    number_of_matrix2_entries: dq 0
    temp_k: dq 1
    remainder: dq 0
    multiplication_method: dq 1
    convolution_type: dq 1
    kernel: times 10000 dd 0
    kernel_size: dq 1
    kernel_size_squared: dq 1
    matrix: times 10000 dd 0
    matrix_size: dq 1
    max_size: dq 0
    result_matrix: times 10000 dd 0
    result_matrix_size: dq 1
    result_matrix_size_squared: dq 1
    row: dq 0
    column: dq 0
    first_column_in_each_row: dq 0
    max_iter: dq 0
    min_index: dq 0
    max_index: dq 0
    number_of_entries: dq 0
    out_of_matrix: dq 0
    ;EXTRA VARIABLES FOR CONVOLUTION USING MATRIX MULTIPLICATION
    use_matrix_multiplication: dq 0
    t: dq 1
    matrix_size_squared: dq 0
    t2: dq 1
    n2t: dq 1
    min_non_zero_column: dq 0
    max_non_zero_column: dq 0
    block_row: dq 0
    ;VARIABLES FOR CALCULATING EXECUTION TIME
    start_time_h: dq 0
    start_time_l: dq 0
    end_time_h: dq 0
    end_time_l: dq 0
    execution_time: dq 0
    ;MESSAGES
    ;defining string messages to interact with user 
    project_title: dq '###COMPUTER STRUCTURE PROJECT###', 10, 0
    project_producer: dq '(produced and developed by Alireza Mirrokni (student number: 401106617))', 10, 0
    project_description: dq 'this is an assembly program to do matrix multiplication and calculate matrix convolution. please enter the number that represents your request (between 1 and 5):', 0
    get_action_number: dq 'please enter the number that represents your next request (between 1 and 5):'
    invalid_action_number: dq 'invalid action number. please enter a number between 1 and 5:', 0
    matrix_multiplication: dq 'matrix multiplication', 0
    calculate_convolution_using_dot_product: dq 'calculate convolution using dot product', 0
    calculate_convolution_using_matrix_multiplication: dq 'calculate convolution using matrix multiplication', 0
    set_multiplication_method: dq 'set multiplication method', 0
    exit: dq 'exit', 0
    main_menu: dq  0, matrix_multiplication, calculate_convolution_using_dot_product, calculate_convolution_using_matrix_multiplication, set_multiplication_method, exit
    exit_message: dq 'hope you enjoyed =D', 10, 0
    get_number_of_matrix1_rows_for_multilplication: dq 'enter the number of rows for the first matrix (a number between 1 and 100):', 0
    get_number_of_matrix1_columns_for_multiplication: dq 'enter the number of columns for the first matrix (a number between 1 and 100):', 0
    get_number_of_matrix2_columns_for_multiplication: dq 'enter the number of columns for the second matrix (a number between 1 and 100):', 0
    invalid_size: dq 'invalid size. please enter a number between 1 and 100:', 0
    input_first_matrix: dq 'please enter the entries of the first matrix:', 0
    input_second_matrix: dq 'please enter the entries of the second matrix:', 0
    multiplication_result: dq 'result:', 0
    get_kernel_size_for_convolution: dq 'please enter the size of the kernel (a number between 1 and 100):', 0
    input_kernel: dq 'please enter the entries of the kernel:', 0
    get_base_matrix_size_for_convolution: dq 'please enter the size of the base matrix (a number between 1 and 100):', 0
    input_base_matrix: dq 'please enter the entries of the base matrix:', 0
    regular: dq 'regular', 0
    edge_extended: dq 'edge extended', 0
    edge_mirrored: dq 'edge mirrored', 0
    zero_edge: dq 'zero edge', 0
    convolution_types: dq 0, regular, edge_extended, edge_mirrored, zero_edge
    get_convolution_type_number: dq 'please enter the number of your desired convolution type (between 1 and 4):', 0
    invalid_convolution_type_number: dq 'invalid convolution type number. please enter a number between 1 and 4:', 0
    convolution_result: dq 'the result of 2-D convolution of the given base matrix and kernel:', 0
    regular_method: dq 'regular method (not using simd and parallel proccessing)', 0
    simd_method: dq 'using simd (parallel proccessing)'
    multiplication_methods: dq 0, regular_method, simd_method
    get_multiplication_method_number: dq 'please enter the number of your desired multiplication method (1 or 2):', 0
    invalid_multiplication_method_number: dq 'invalid multiplication method number. please enter either 1 or 2:', 0
    set_multiplication_method_successful: dq 'multiplication method has been set successfully!', 0
    execution_time_in_nanoseconds: dq 'execution time in nano seconds:', 0



segment .text
    global asm_main                         ;global function asm_main
    global read_matrix                      ;global function read_matrix
    global print_matrix                     ;global function print_matrix
    extern printf                           ;external function printf 

asm_main:
	push rbp            ;saving the value of base pointer in order to restore it after executing the program
    push rbx            ;saving the value of rbx register in order to restore it value after executing the program
    push r12            ;saving the value of r12 to r15 registers in order to restore them after executing the program
    push r13            
    push r14            
    push r15           

    sub rsp, 8          ;aligning the stack with subtracting 8 from stack pointer

    call start          ;calling start subroutine which starts the program 

    add rsp, 8          ;restoring the initial value of the stack pointer

	pop r15             ;restoring the initial values of r12 to r15 registers from top of the stack
	pop r14             
	pop r13             
	pop r12             
    pop rbx             ;restoring the initial value of rbx register from top of the stack
    pop rbp             ;restoring the initial value of base pointer from top of the stack

ret

start:
    sub rsp, 8          ;aligning the stack

    mov rdi, project_title  ;printing start program messages
    call print_string
    mov rdi, project_producer
    call print_string
    mov rdi, project_description
    call print_string
    jmp print_menu

    input_loop:
        mov rdi, get_action_number  ;printing get action number messages (printing the message every time that user executes an action successfully and turns back to main menu)
        call print_string

        print_menu:             
        mov r12, 1                  ;setting r12 to 1 to use it as a counter

        print_menu_loop:            ;looping for printing the menu 
            mov rdi, r12            ;print the current action
            call print_int
            mov rdi, '-'
            call print_char
            mov rdi, ' '
            call print_char
            mov rdi, [main_menu + r12 * 8]
            call print_string
            inc r12                 ;updating the value of the counter (r12 register)
            cmp r12, 6              ;comparing counter with 5 and jumping back to the start of the loop if counter value is less than 5 or jumping to the next part for getting action number from the user
            jl print_menu_loop
            jmp input_action        

        input_action_loop:
            call print_nl                                   ;printing the invalid_action_number message if user enters an invalid action number and then jumping back to print_menu to get action number from the user once again
            mov rdi, invalid_action_number
            call print_string
            jmp print_menu

            input_action:                                   ;getting the action number from the user
            call extract_int
            cmp rax, 1                                      ;jumping to matrix_multiplication_execution if the user enters 1
            je matrix_multiplication_execution      
            cmp rax, 2                                      ;jumping to calculate_convolution_execution if the user enters 2
            mov qword[use_matrix_multiplication], 0         ;setting 'use_matrix_multiplication' to 0 in this case
            mov qword[max_size], 100                        ;setting 'max_size' to 100 in this case
            je calculate_convolution_execution
            cmp rax, 3                                      ;jumping to calculate_convolution_execution if the user enters 3
            mov qword[use_matrix_multiplication], 1         ;setting 'use_matrix_multiplication' to 1 in this case
            mov qword[max_size], 10                         ;setting 'max_size' to 10 in this case
            je calculate_convolution_execution
            cmp rax, 4                                      ;jumping to set_multiplication_method_execution if the user enters 3
            je set_multiplication_method_execution
            cmp rax, 5                                      ;jumping to finish if the user enters 4
            je finish
            jmp input_action_loop                           ;jumping to input_action_loop to inform the user that his/her chosen action number is invalid

        matrix_multiplication_execution:
            call multiplication             ;calling multiplication subroutine
            jmp input_loop                  ;jumping to input_loop to do user's other desired actions
        
        calculate_convolution_execution:
            call convolution                ;calling convolution subroutine
            jmp input_loop                  ;jumping to input_loop to do user's other desired actions
        
        set_multiplication_method_execution:
            call method                     ;calling method subroutine
            jmp input_loop                  ;jumping to input_loop to do user's other desired actions

    finish:
    call print_nl                    ;printing the end of program message :)
    mov rdi, exit_message
    call print_string

    add rsp, 8              ;restoring the initial value of the stack pointer

ret

multiplication:
    sub rsp, 8          ;aligning the stack

    call print_nl               ;printing get_matrix1_number_of_rows_for_multilplication message
    mov rdi, get_number_of_matrix1_rows_for_multilplication
    call print_string
    jmp get_number_of_matrix1_rows

    get_number_of_matrix1_rows_loop:              ;looping for getting the number of matrix1 rows
        call print_nl           ;printing the invalid_size message if user enters an invalid number of rows 
        mov rdi, invalid_size
        call print_string

        get_number_of_matrix1_rows:
        call extract_int           ;getting the number of rows from the user
        cmp rax, 1              ;jumping to get_number_of_matrix1_rows_loop if the user enters a number less than 1
        jl get_number_of_matrix1_rows_loop
        cmp rax, 100           ;jumping to get_number_of_matrix1_rows_loop if the user enters a number greater than 100
        jg get_number_of_matrix1_rows_loop
        mov qword[n], rax       ;saving the number of matrix1 rows in the variable 'n'
    
    call print_nl               ;printing get_number_of_matrix1_columns_for_multiplication message
    mov rdi, get_number_of_matrix1_columns_for_multiplication
    call print_string
    jmp get_number_of_matrix1_columns

    get_number_of_matrix1_columns_loop:              ;looping for getting the number of matrix1 columns
        call print_nl           ;printing the invalid_size message if user enters an invalid number of columns
        mov rdi, invalid_size
        call print_string

        get_number_of_matrix1_columns:
        call extract_int           ;getting the number of columns from the user
        cmp rax, 1              ;jumping to get_number_of_matrix1_columns_loop if the user enters a number less than 1
        jl get_number_of_matrix1_columns_loop
        cmp rax, 100           ;jumping to get_number_of_matrix1_columns_loop if the user enters a number greater than 100
        jg get_number_of_matrix1_columns_loop
        mov qword[k], rax       ;saving the number of matrix1 columns in the variable 'k'

    imul rax, qword[n]                             ;calculating the number of matrix1 entries using imul instruction
    mov qword[number_of_matrix1_entries], rax      ;saving the the number of matrix1 entries in the variable 'number_of_matrix1_entries'
    
    call print_nl               ;printing input_first_matrix message
    mov rdi, input_first_matrix
    call print_string           
    mov rbp, matrix1                                    ;moving the address of matrix1 to rbp in order to use it as an argument for read_matrix subroutine
    mov r13, qword[number_of_matrix1_entries]           ;moving the number of matrix1 entries to r13 in order to use it as an argument for read_matrix subroutine
    call read_matrix                                    ;calling read_matrix subroutine to get the entries of matrix1 from the user

    call print_nl               ;printing get_number_of_matrix2_columns_for_multiplication message
    mov rdi, get_number_of_matrix2_columns_for_multiplication
    call print_string
    jmp get_number_of_matrix2_columns

    get_number_of_matrix2_columns_loop:              ;looping for getting the number of matrix2 columns
        call print_nl           ;printing the invalid_size message if user enters an invalid number of columns
        mov rdi, invalid_size
        call print_string

        get_number_of_matrix2_columns:
        call extract_int           ;getting the number of columns from the user
        cmp rax, 1              ;jumping to get_number_of_matrix2_columns_loop if the user enters a number less than 1
        jl get_number_of_matrix2_columns_loop
        cmp rax, 100           ;jumping to get_number_of_matrix2_columns_loop if the user enters a number greater than 100
        jg get_number_of_matrix2_columns_loop
        mov qword[m], rax       ;saving the number of matrix2 columns in the variable 'm'

    imul rax, qword[k]                             ;calculating the number of matrix2 entries using imul instruction
    mov qword[number_of_matrix2_entries], rax      ;saving the the number of matrix2 entries in the variable 'number_of_matrix2_entries'

    call print_nl               ;printing input_second_matrix message
    mov rdi, input_second_matrix    
    call print_string
    mov rbp, matrix2                                    ;moving the address of matrix2 to rbp in order to use it as an argument for read_matrix subroutine
    mov r13, qword[number_of_matrix2_entries]            ;moving the number of matrix2 entries to r13 in order to use it as an argument for read_matrix subroutine
    call read_matrix                                    ;calling read_matrix subroutine to get the entries of matrix2 from the user

    call print_nl               ;printing multiplication_result message
    mov rdi, multiplication_result
    call print_string

    cmp qword[multiplication_method], 1     ;comparing the multiplication_method with 1 and jumping to do the multiplication ordinary if it is equal to 1
    je ordinary_product
    call prepare_for_multiply_matrices_packed   ;calling prepare_for_multiply_matrices_packed subroutine
    call save_start_time                    ;calling save_start_time subroutine to save the start time of procedure
    call multiply_matrices_packed           ;calling multiply_matrices_packed subroutine to do the matrix multiplication using simd
    call calculate_execution_time           ;calling calculate_execution_time subroutine to calculate the execution time of procedure
    mov rbp, product_matrix_packed          ;moving the address of product_matrix_packed to rbp in order to use it as an argument for print_matrix subroutine
    jmp multiplication_print_result         ;jumping to multiplication_print_result in order to print the result

    ordinary_product:
    call save_start_time                    ;calling save_start_time subroutine to save the start time of procedure
    call multiply_matrices                  ;calling multiply_matrices subroutine to do the matrix multiplication without using simd
    call calculate_execution_time           ;calling calculate_execution_time subroutine to calculate the execution time of procedure
    mov rbp, product_matrix                 ;moving the address of product_matrix to rbp in order to use it as an argument for print_matrix subroutine

    multiplication_print_result:
    mov r13, qword[n]                       ;moving the number of product matrix rows to r13 in order to use it as an argument for print_matrix subroutine
    mov r14, qword[m]                       ;moving the number of product matrix columns to r14 in order to use it as an argument for print_matrix subroutine
    call print_matrix                       ;calling print_matrix subroutine to print the entries of result product matrix
    call print_nl
    mov rdi, execution_time_in_nanoseconds      ;printing execution_time_in_nanoseconds message
    call print_string
    mov rdi, qword[execution_time]              ;printing execution_time
    call print_int
    call print_nl
    call print_nl
    
    add rsp, 8      ;restoring the initial value of the stack pointer           

ret

convolution:        
    sub rsp, 8      ;aligning the stack

    call print_nl           ;printing get_kernel_size_for_convolution message
    mov rdi, get_kernel_size_for_convolution
    call print_string
    jmp get_kernel_size

    get_kernel_size_loop:       ;looping for getting the size of kernel
        call print_nl           ;printing the invalid_size message if user enters an invalid kernel size
        mov rdi, invalid_size
        call print_string

        get_kernel_size:
        call extract_int           ;getting the kernel size from the user
        cmp rax, 1              ;jumping to get_kernel_size_loop if the user enters a number less than 1
        jl get_kernel_size_loop
        cmp rax, qword[max_size]           ;jumping to get_kernel_size_loop if the user enters a number greater than 100
        jg get_kernel_size_loop
        mov qword[kernel_size], rax     ;saving the kernel size in the variable 'kernel_size'

    call print_nl               ;printing input_kernel message
    mov rdi, input_kernel
    call print_string
    mov rbp, kernel             ;moving the address of kernel to rbp in order to use it as an argument for read_matrix subroutine
    mov rax, qword[kernel_size] ;moving the value of kernel size to rax in order to calculate the kernel size squared
    imul rax, rax               ;calculating the kernel size squared using imul instruction
    mov r13, rax                ;moving the value of kernel size squared to r13 in order to use it as an argument for read_matrix subroutine
    call read_matrix            ;calling read_matrix subroutine to get the entries of kernel from the user

    call print_nl               ;printing get_base_matrix_size_for_convolution message
    mov rdi, get_base_matrix_size_for_convolution
    call print_string
    jmp get_base_matrix_size

    get_base_matrix_size_loop:      ;looping for getting the size of base matrix
        call print_nl               ;printing the invalid_size message if user enters an invalid matrix size
        mov rdi, invalid_size
        call print_string

        get_base_matrix_size:
        call extract_int               ;getting the matrix size from the user
        cmp rax, 1                  ;jumping to get_base_matrix_size_loop if the user enters a number less than 1
        jl get_base_matrix_size_loop    
        cmp rax, 100               ;jumping to get_base_matrix_size_loop if the user enters a number greater than 100
        jg get_base_matrix_size_loop
        mov qword[matrix_size], rax     ;saving the base matrix size in the variable 'matrix_size'

    call print_nl                   ;printing input_base_matrix message
    mov rdi, input_base_matrix
    call print_string
    mov rbp, matrix                 ;moving the address of base matrix to rbp in order to use it as an argument for read_matrix subroutine
    mov rax, qword[matrix_size]     ;moving the value of base matrix size to rax in order to calculate the base matrix size squared
    imul rax, rax                   ;calculating the base matrix size squared using imul instruction
    mov r13, rax                    ;moving the value of base matrix size squared to r13 in order to use it as an argument for read_matrix subroutine
    call read_matrix                ;calling read_matrix subroutine to get the entries of base matrix from the user

    cmp qword[use_matrix_multiplication], 1                 ;checking if the user wants to calculate convolution using matrix multiplication
    je convolution_using_matrix_multiplication_execution
    
    call print_nl                   ;printing get_convolution_type_number message
    mov rdi, get_convolution_type_number
    call print_string

    print_convolution_types:
    mov r12, 1              ;setting r12 to 1 to use it as a counter                      

    print_convolution_types_loop:       ;looping for printing the convolution types
        mov rdi, r12                    ;printing the current convolution type
        call print_int
        mov rdi, '.'
        call print_char
        mov rdi, ' '
        call print_char
        mov rdi, [convolution_types + r12 * 8]
        call print_string
        inc r12                         ;updating the value of the counter (r12 register)
        cmp r12, 5                      ;comparing counter with 5 and jumping back to the start of the loop if counter value is less than 5 or jumping to the next part for getting convolution type number from the user
        jl print_convolution_types_loop
        jmp input_convolution_type

    input_convolution_type_loop:       
        call print_nl                   ;printing the invalid_convolution_type_number message if user enters an invalid convolution type number and then jumping back to print_convolution_types to get convolution type number from the user once again   
        mov rdi, invalid_convolution_type_number
        call print_string
        jmp print_convolution_types

        input_convolution_type:         ;getting the convolution type number from the user
        call extract_int                   
        cmp rax, 1                      ;jumping to input_convolution_type_loop if the user enters a number less than 1
        jl input_convolution_type_loop
        cmp rax, 4                      ;jumping to input_convolution_type_loop if the user enters a number greater than 4
        jg input_convolution_type_loop  
        mov qword[convolution_type], rax    ;saving the convolution type in the variable 'convolution_type'
        cmp rax, 1                          ;comparing convolution type with 1 and jumping to regular_convolution_execution if convolution type is equal to 1 in order to do the regular convolution
        je regular_convolution_execution
        call save_start_time                ;calling save_start_time subroutine to save the start time of procedure
        call edge_handling_convolution      ;calling edge_handling_convolution subroutine to do the convolution with edge handling
        call calculate_execution_time       ;calling calculate_execution_time subroutine to calculate the execution time of procedure
        jmp print_convolution_result        ;jumping to print_convolution_result  in order to print the result convolution matrix
            
    regular_convolution_execution:
    call save_start_time                    ;calling save_start_time subroutine to save the start time of procedure
    call regular_convolution                ;calling regular_convolution subroutine to do regular convolution 
    call calculate_execution_time           ;calling calculate_execution_time subroutine to calculate the execution time of procedure
    jmp print_convolution_result            ;jumping to print_convolution_result  in order to print the result convolution matrix

    convolution_using_matrix_multiplication_execution:
    call save_start_time                            ;calling save_start_time subroutine to save the start time of procedure
    call convolution_using_matrix_multiplication    ;calling convolution_using_matrix_multiplication subroutine to do regular convolution using matrix multiplication
    call calculate_execution_time                   ;calling calculate_execution_time subroutine to calculate the execution time of procedure

    print_convolution_result:
    call print_nl
    mov rdi, convolution_result
    call print_string
    mov r13, qword[result_matrix_size]  ;moving the value of result matrix size to r13 in order to use it as an argument for print_matrix subroutine
    mov r14, qword[result_matrix_size]  ;moving the value of result matrix size to r14 in order to use it as an argument for print_matrix subroutine
    mov rbp, result_matrix              ;moving the address of result_matrix to rbp in order to use it as an argument for print_matrix subroutine
    call print_matrix                   ;calling print_matrix subroutine to print the entries of result matrix
    call print_nl
    mov rdi, execution_time_in_nanoseconds      ;printing execution_time_in_nanoseconds message
    call print_string
    mov rdi, qword[execution_time]              ;printing execution_time
    call print_int
    call print_nl
    call print_nl

    add rsp, 8          ;restoring the initial value of the stack pointer           

ret

method:
    sub rsp, 8          ;aligning the stack

    call print_nl       ;printing get_multiplication_method_number message
    mov rdi, get_multiplication_method_number
    call print_string

    print_multiplication_methods:
    mov r12, 1          ;setting r12 to 1 to use it as a counter

    print_multiplication_methods_loop:      ;looping for printing the multiplication methods
        mov rdi, r12                        ;printing the current multiplication method
        call print_int
        mov rdi, '.'
        call print_char
        mov rdi, ' '
        call print_char
        mov rdi, [multiplication_methods + r12 * 8]
        call print_string
        inc r12                             ;updating the value of the counter (r12 register)
        cmp r12, 3                          ;comparing counter with 3 and jumping back to the start of the loop if counter value is less than 3 or jumping to the next part for getting multiplication method number from the user
        jl print_multiplication_methods_loop
        jmp input_multiplication_method

    input_multiplication_method_loop:
        call print_nl                       ;printing the invalid_multiplication_method_number message if user enters an invalid multiplication method number and then jumping back to print_multiplication_methods to get multiplication method number from the user once again   
        mov rdi, invalid_multiplication_method_number
        call print_string
        jmp print_multiplication_methods

        input_multiplication_method:        ;getting the multiplication method number from the user
        call extract_int
        cmp rax, 1                          ;jumping to input_multiplication_method_loop if the user enters a number less than 1
        jl input_multiplication_method_loop
        cmp rax, 2                          ;jumping to input_multiplication_method_loop if the user enters a number greater than 2
        jg input_multiplication_method_loop
        mov qword[multiplication_method], rax   ;saving the multiplication method in the variable 'multiplication_method'
    
    call print_nl           ;printing set_multiplication_method_successful message
    mov rdi, set_multiplication_method_successful
    call print_string
    call print_nl

    add rsp, 8          ;restoring the initial value of the stack pointer

ret
    

multiply_matrices:
    sub rsp, 8          ;aligning the stack

    xor r12, r12        ;setting r12 to 0 using xor instruction
    xor r13, r13        ;setting r13 to 0 using xor instruction
    pxor xmm1, xmm1     ;setting xmm1 to 0 using pxor instruction

    multiply_matrices_loop_1:           ;looping through the rows of the result product matrix
        multiply_matrices_loop_2:       ;looping through the columns of the result product matrix
            mov dword[sum], 0           ;setting 'sum' variable to 0
            xor r14, r14                ;setting r14 to 0 using xor instruction

            multiply_matrices_loop_3:   ;looping through the current row of matrix1 and the current column of matrix2 
                mov rax, r12            ;calculating the index of current entry of matrix1 (r12 * k + r14) 
                imul rax, qword[k]
                add rax, r14
                movss xmm1, dword[matrix1 + rax * 4]    ;moving the current entry of matrix1 to xmm1 (xmm1 is used to save floating point values and do arithmatic operations on them)

                mov rax, r14            ;calculating the index of current entry of matrix2 (r14 * m + r13)
                imul rax, qword[m]
                add rax, r13
                mulss xmm1, dword[matrix2 + rax * 4]    ;multiplying the current entry of matrix1 with xmm1 and saving it in xmm1

                addss xmm1, dword[sum]          ;adding current value of 'sum' variable with xmm1 and saving it in xmm1 in order to save it in floating point format
                movss dword[sum], xmm1          ;moving the floating point value stored in xmm1 to 'sum' variable

                inc r14                         ;updating the value of the counter (r14 register)
                cmp r14, qword[k]               ;comparing counter with 'k' and jumping back to the start of loop3 if counter value is less than 'k' 
                jl multiply_matrices_loop_3
            
            mov rax, r12                        
            imul rax, qword[m]              ;calculating the index of current entry of product matrix (r12 * m + r13) 
            add rax, r13
            mov ebx, dword[sum]             ;moving the variable 'sum' to the current entry of product matrix using ebx register
            mov dword[product_matrix + rax * 4], ebx

            inc r13                     ;updating the value of the current column (r13 register)
            cmp r13, qword[m]           ;comparing current column with 'm' and jumping back to the start of loop2 if current column value is less than 'm' 
            jl multiply_matrices_loop_2
        
        xor r13, r13            ;setting r13 to 0 using xor instruction
        inc r12                 ;updating the value of the current row (r12 register)                         
        cmp r12, qword[n]       ;comparing current row with 'n' and jumping back to the start of loop1 if current row value is less than 'n'   
        jl multiply_matrices_loop_1
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

prepare_for_multiply_matrices_packed:
    sub rsp, 8                  ;aligning the stack

    xor r12, r12            ;setting r12 to 0 using xor instruction
    xor r13, r13            ;setting r13 to 0 using xor instruction

    call calculate_matrix2_transpose        ;calling calculate_matrix2_transpose subroutine
    call append_zeros                       ;calling append_zeros subroutine. this subroutine appends zeroes to matrix1 and matrix2_transpose in order to make their sizes divisible by 4

    add rsp, 8                  ;restoring the initial value of the stack pointer

ret

multiply_matrices_packed:
    sub rsp, 8              ;aligning the stack

    xor r12, r12            ;setting r12 to 0 using xor instruction
    xor r13, r13            ;setting r13 to 0 using xor instruction
    pxor xmm1, xmm1         ;setting xmm1 to 0 using pxor instruction

    ;calculating the entries of product matrix packed with iterating through its rows and columns
    ;it uses the same logic as multiply_matrices subroutine above
    ;so i just explain the part which is different from multiply_matrices subroutine
    multiply_matrices_packed_loop_1:
        multiply_matrices_packed_loop_2:
            mov dword[sum_packed], 0
            xor r14, r14

            multiply_matrices_packed_loop_3:
                mov rax, r12
                imul rax, qword[temp_k]
                add rax, r14
                movups xmm0, [temp_matrix1 + rax * 4]               ;moving 4 of matrix1 entries to xmm0 register

                mov rax, r13
                imul rax, qword[temp_k]
                add rax, r14
                movups xmm1, [temp_matrix2_transpose + rax * 4]     ;moving 4 of matrix2_transpose entries to xmm1 register

                dpps xmm1, xmm0, 0xF1                               ;calculating the dot product of vectors stored in xmm1 and xmm0 and storing the result in xmm1

                addss xmm1, dword[sum_packed]
                movss dword[sum_packed], xmm1

                add r14, 4
                cmp r14, qword[k]
                jl multiply_matrices_packed_loop_3
            

            mov rax, r12
            imul rax, qword[m]
            add rax, r13
            movss xmm1, dword[sum_packed]
            movss dword[product_matrix_packed + rax * 4], xmm1

            inc r13
            cmp r13, qword[m]
            jl multiply_matrices_packed_loop_2
        
        xor r13, r13
        inc r12
        cmp r12, qword[n]
        jl multiply_matrices_packed_loop_1

    add rsp, 8              ;restoring the initial value of the stack pointer

ret

calculate_matrix2_transpose:
    sub rsp, 8              ;aligning the stack

    calculate_matrix2_transpose_outer_loop:                 ;calculating matrix2_transpose with looping through its rows and columns
            calculate_matrix2_transpose_inner_loop:
                mov r14, r12                                    ;calculating the index of current entry of matrix2 (r12 * m + r13)                     
                imul r14, qword[m]
                add r14, r13
                mov eax, dword[matrix2 + r14 * 4]               ;moving the current entry of matrix2 to eax 

                mov r14, r13                                    ;calculating the index of current entry of matrix2_transpose (r13 * k + r12)
                imul r14, qword[k]
                add r14, r12
                mov dword[matrix2_transpose + r14 * 4], eax     ;moving the value stored in eax to the current entry of matrix2_transpose 

                inc r13                                         ;updating the value of the current column (r13 register)    
                cmp r13, qword[m]                               ;comparing current column with 'm' and jumping back to the start of inner loop if current column value is less than 'm' 
                jl calculate_matrix2_transpose_inner_loop
            
            xor r13, r13                ;setting r13 to 0 using xor instruction
            inc r12                     ;updating the value of the current row (r12 register)                                       
            cmp r12, qword[k]           ;comparing current row with 'k' and jumping back to the start of outer loop if current row value is less than 'k'   
            jl calculate_matrix2_transpose_outer_loop  
    
    add rsp, 8              ;restoring the initial value of the stack pointer

ret

append_zeros:
    sub rsp, 8          ;aligning the stack

    mov rax, qword[k]       ;moving the variable 'n' to rax  
    mov rbx, 4              ;moving 4 to rbx
    xor rdx, rdx        
    idiv rbx                ;dividing the value stored in rax by 4
    mov qword[remainder], 4     ;storing the value 4 - remainder in the variable 'remainder' in order to use it to calculate number of zeroes appendded in each row 
    sub qword[remainder], rdx
    inc rax                     ;storing the first integer that is greater than 'n' and is divisible by 4 in the variable 'temp_n'
    imul rax, 4
    mov qword[temp_k], rax

    xor r12, r12            ;setting r12 to 0 using xor instruction
    xor r13, r13            ;setting r13 to 0 using xor instruction    

    append_zeros_outer_loop1:
        append_zeros_inner_loop1:
            mov r14, r12                                ;calculating the index of current entry of temp_matrix1 (r12 * k + r13)
            imul r14, qword[temp_k]
            add r14, r13
                        
            cmp r13, qword[k]                           ;checking if the value of column number is not less than 'k'. if the condition holds,  moving 0 to the current entry of temp_matrix1 
            jge append_zero1

            mov r11, qword[remainder]                   ;calculating the index of current entry of matrix1 (r12 * (k + remainder) + r13)  
            imul r11, r12
            sub r14, r11
            mov ebx, dword[matrix1 + r14 * 4]           ;moving the current entry of matrix1 to ebx

            add r14, r11                                ;calculating the index of current entry of temp_matrix1 (r12 * (k + remainder) + r13 - r12 * remainder = r12 * k + r13)
            mov dword[temp_matrix1 + r14 * 4], ebx      ;moving the value stored in ebx to the current entry of temp_matrix1    
            jmp append_zeros_inner_loop_condition1  

            append_zero1:
            mov dword[temp_matrix1 + r14 * 4], 0        ;moving 0 to the current entry of temp_matrix1

            append_zeros_inner_loop_condition1:
            inc r13                                     ;updating the value of the current column (r13 register)
            cmp r13, qword[temp_k]                      ;comparing current column with 'temp_k' and jumping back to the start of inner loop if current column value is less than 'temp_k'
            jl append_zeros_inner_loop1
        
        xor r13, r13                    ;setting r13 to 0 using xor instruction
        inc r12                         ;updating the value of the current row (r12 register) 
        cmp r12, qword[n]               ;comparing current row with 'n' and jumping back to the start of outer loop if current row value is less than 'n'
        jl append_zeros_outer_loop1

    xor r12, r12                ;setting r12 to 0 using xor instruction
    xor r13, r13                ;setting r13 to 0 using xor instruction
        
    append_zeros_outer_loop2:
        append_zeros_inner_loop2:
            mov r14, r12                                            ;calculating the index of current entry of temp_matrix2_transpose (r12 * k + r13)                                     
            imul r14, qword[temp_k]
            add r14, r13

            cmp r13, qword[k]                                       ;checking the value of column number is not less than 'k'. if the condition holds,  moving 0 to the current entry of temp_matrix2_transpose
            jge append_zero2

            mov r11, qword[remainder]                               ;calculating the index of current entry of matrix2_transpose (r12 * (k + remainder) + r13)  
            imul r11, r12
            sub r14, r11
            mov ebx, dword[matrix2_transpose + r14 * 4]             ;moving the current entry of matrix2_transpose to ebx     

            add r14, r11                                            ;calculating the index of current entry of temp_matrix2_transpose (r12 * (k + remainder) + r13 - r12 * remainder = r12 * k + r13)
            mov dword[temp_matrix2_transpose + r14 * 4], ebx        ;moving the value stored in ebx to the current entry of temp_matrix2_transpose      
            jmp append_zeros_inner_loop_condition2

            append_zero2:
            mov dword[temp_matrix2_transpose + r14 * 4], 0          ;moving 0 to the current entry of temp_matrix2_transpose

            append_zeros_inner_loop_condition2:
            inc r13                                                 ;updating the value of the current column (r13 register)
            cmp r13, qword[temp_k]                                  ;comparing current column with 'temp_k' and jumping back to the start of inner loop if current column value is less than 'temp_k'
            jl append_zeros_inner_loop2
        
        xor r13, r13                    ;setting r13 to 0 using xor instruction
        inc r12                         ;updating the value of the current row (r12 register) 
        cmp r12, qword[n]               ;comparing current row with 'n' and jumping back to the start of outer loop if current row value is less than 'n'
        jl append_zeros_outer_loop2
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret 

multiply_entries:
    sub rsp, 8          ;aligning the stack

    mov dword[sum], 0       ;setting the variable 'sum' to 0
    xor r12, r12            ;setting r12 to 0 using xor instruction
    pxor xmm1, xmm1         ;setting xmm1 to 0 using pxor instruction

    multiply_entries_loop:      ;looping through the entries of matrix1 and matrix2 in order to calculate their dot product
        movss xmm1, dword[matrix1 + r12 * 4]        ;moving the current entry of matrix1 to xmm1 
        mulss xmm1, dword[matrix2 + r12 * 4]        ;multiplying the current entry of matrix2 with the value stored in xmm1 and saving the result in xmm1

        addss xmm1, dword[sum]                      ;adding current value of 'sum' variable with xmm1 and saving it in xmm1 in order to save it in floating point format
        movss dword[sum], xmm1                      ;moving the floating point value stored in xmm1 to 'sum' variable

        inc r12                     ;updating the value of the counter (r12 register)
        cmp r12, qword[number_of_matrix1_entries]          ;comparing counter with 'number_of_matrix1_entries' and jumping back to the start of loop if counter value is less than 'number_of_matrix1_entries'     
        jl multiply_entries_loop
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

multiply_entries_packed:
    sub rsp, 8          ;aligning the stack

    mov dword[sum_packed], 0        ;setting the variable 'sum_packed' to 0
    xor r12, r12                    ;setting r12 to 0 using xor instruction                   

    multiply_entries_packed_loop:
        movups xmm0, [matrix1 + r12 * 4]        ;moving 4 of matrix1 entries to xmm0 register    
        movups xmm1, [matrix2 + r12 * 4]        ;moving 4 of matrix2 entries to xmm1 register

        dpps xmm1, xmm0, 0xF1                   ;calculating the dot product of vectors stored in xmm1 and xmm0 and storing the result in xmm1

        addss xmm1, dword[sum_packed]           ;adding current value of 'sum_packed' variable with xmm1 and saving it in xmm1 in order to save it in floating point format
        movss dword[sum_packed], xmm1           ;moving the floating point value stored in xmm1 to 'sum_packed' variable

        add r12, 4                      ;updating the value of the counter (r12 register)
        cmp r12, qword[number_of_matrix1_entries]              ;comparing counter with 'number_of_matrix1_entries' and jumping back to the start of loop if counter value is less than 'number_of_matrix1_entries'
        jl multiply_entries_packed_loop
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

regular_convolution:
    sub rsp, 8          ;aligning the stack

    call build_kernel_for_convolution           ;calling build_kernel_for_convolution subroutine to transfer kernel entries to matrix1 entries 
    call calculate_result_matrix_size           ;calling calculate_result_matrix_size  subroutine to calculate the size of the result matrix of convolution

    xor r14, r14                ;setting r14 to 0 using xor instruction

    regualr_convolution_loop:
        ;calculating the coordinates of the top left entry of overlapping region between the kernel and the base matrix using idiv 
        mov rax, r14                                ;moving the value stored in r14 to rax
        mov rbx, qword[result_matrix_size]          ;moving the variable 'result_matrix_size' to rbx
        xor rdx, rdx
        idiv rbx                                    ;dividing the value stored in rax by the value stored in rbx
        mov qword[row], rax                         ;storing the quotient in the variable 'row'        
        mov qword[first_column_in_each_row], rdx    ;storing the remainder in both variables 'first_column_in_each_row' and 'column'    
        mov qword[column], rdx

        xor r13, r13                            ;setting r13 to 0 using xor instruction
        call build_matrix2_for_convolution      ;calling build_matrix2_for_convolution to build matrix2
        
        cmp qword[multiplication_method], 1     ;comparing the variable 'multiplication_method' and jumping to regular_convolution_dot_product if it is equal to 1, to calculate the dot product of 2 matrices without using simd 
        je regular_convolution_dot_product
        call multiply_entries_packed            ;calling multiply_entries_packed to calculate the dot product of 2 matrices using simd
        mov ebx, dword[sum_packed]              ;transfering the variable 'sum_packed' to the current entry of result_matrix using ebx
        mov dword[result_matrix + r14 * 4], ebx
        jmp regular_convolution_loop_condition

        regular_convolution_dot_product:
        call multiply_entries                   ;calling multiply_entries to calculate the dot product of 2 matrices without using simd
        mov ebx, dword[sum]                     ;transfering the variable 'sum' to the current entry of result_matrix using ebx
        mov dword[result_matrix + r14 * 4], ebx

        regular_convolution_loop_condition:
        inc r14                                             ;updating the value of the counter (r14 register)
        cmp r14, qword[result_matrix_size_squared]          ;comparing counter with result matrix size squared and jumping back to the start of loop3 if counter value is less than result matrix size squared
        jl regualr_convolution_loop
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

edge_handling_convolution:
    sub rsp, 8          ;aligning the stack

    call build_kernel_for_convolution               ;calling build_kernel_for_convolution subroutine to transfer kernel entries to matrix1 entries
    call calculate_result_matrix_size               ;calling calculate_result_matrix_size  subroutine to calculate the size of the result matrix of convolution

    ;calculating min_iter and max_iter using idiv
    mov rax, qword[kernel_size]             ;moving the variable 'kernel_size' to rax
    mov rbx, 2                              ;moving 2 to rbx
    xor rdx, rdx    
    idiv rbx                                ;dividing the value stored in rax by the value stored in rbx     
    mov r14, rax                            ;moving the quotient to r14
    dec rdx                                 ;decreasing the remainder
    mov qword[max_iter], rdx                ;moving the value stored in rdx to the variable 'max_iter'
    add qword[max_iter], rax                ;adding the variable 'max_iter' with the quotient and storing the result in the variable 'max_iter'
    mov rax, qword[matrix_size]             ;adding the variable 'matrix_size' with the variable 'max_iter' and storing it in the variable 'max_iter' using rax
    add qword[max_iter], rax

    neg r14                                 ;negating r14 and moving it to both variables 'row' and 'column'
    mov qword[row], r14
    mov qword[column], r14

    mov qword[min_index], r14               ;moving r14 to the variable 'min_index'
    mov rax, qword[matrix_size]             ;calculating 'max_index' from 'matrix_size' and r14 using rax ('max_index' = 'matrix_size' + r14)
    mov qword[max_index], rax
    add qword[max_index], r14

    xor r14, r14                    ;setting r14 to 0 using xor instruction

    edge_handling_convolution_outer_loop:
        edge_handling_convolution_inner_loop:
            mov rdx, qword[column]                      ;transfering the variable 'column' to the variable 'first_column_in_each_row' using rdx
            mov qword[first_column_in_each_row], rdx

            push qword[row]                             ;storing the values of variables 'row' and 'column' in order to restore them
            push qword[column]

            call build_matrix2_for_convolution          ;calling build_matrix2_for_convolution to build matrix2

            pop qword[column]                           ;restoring the values of variable 'row' and 'column' from top of the stack
            pop qword[row]
            
            cmp qword[multiplication_method], 1         ;comparing the variable 'multiplication_method' and jumping to regular_convolution_dot_product if it is equal to 1, to calculate the dot product of 2 matrices without using simd 
            je edge_handling_convolution_dot_product
            call multiply_entries_packed                ;calling multiply_entries_packed to calculate the dot product of 2 matrices using simd
            mov ebx, dword[sum_packed]                  ;transfering the variable 'sum_packed' to the current entry of result_matrix using ebx
            mov dword[result_matrix + r14 * 4], ebx
            jmp edge_handling_convolution_loop_condition

            edge_handling_convolution_dot_product:
            call multiply_entries                       ;calling multiply_entries to calculate the dot product of 2 matrices without using simd
            mov ebx, dword[sum]                         ;transfering the variable 'sum' to the current entry of result_matrix using ebx
            mov dword[result_matrix + r14 * 4], ebx

            edge_handling_convolution_loop_condition:
            inc r14                             ;updating the value of the counter (r14 register)
            inc qword[column]                   ;updating the value of the current column
            mov rax, qword[max_index]           
            cmp qword[column], rax              ;comparing current column with 'max_index' and jumping back to the start of inner loop if current column value is less than 'max_index'
            jl edge_handling_convolution_inner_loop

        mov rax, qword[min_index]               ;transfering the variable 'min_index' to the variable 'column' using rax
        mov qword[column], rax 
        inc qword[row]                          ;updating the value of the current row
        mov rax, qword[max_index]
        cmp qword[row], rax                     ;comparing current row with 'max_index' and jumping back to the start of outer loop if current row value is less than 'max_index'
        jl edge_handling_convolution_outer_loop
    
    add rsp, 8          ;restoring the initial value of the stack pointer
ret

build_kernel_for_convolution:
    sub rsp, 8          ;aligning the stack

    ;calculating kernel size squared using imul
    mov rax, qword[kernel_size]                                             ;moving the variable 'kernel_size' to rax
    imul rax, rax                                                           ;squaring the value stored in rax
    mov qword[kernel_size_squared], rax                                     ;moving the kernel size squared from rax to the variable 'kernel_size_squared'
    mov qword[number_of_matrix1_entries], rax                               ;moving the kernel size squared from rax to the variable 'number_of_matrix1_entries'

    xor r14, r14                ;setting r14 to 0 using xor instruction                                       

    transfer_kernel_to_matrix1_loop:
        mov ebx, dword[kernel + r14 * 4]            ;transfering the current entry of kernel to the same entry in matrix1 using ebx 
        mov dword[matrix1 + r14 * 4], ebx
        inc r14                                     ;updating the value of the counter (r14 register)        
        cmp r14, qword[kernel_size_squared]         ;comparing counter with 'kernel_size_squared' and jumping back to the start of loop if counter value is less than 'kernel_size_squared'
        jl transfer_kernel_to_matrix1_loop

    add rsp, 8          ;restoring the initial value of the stack pointer
ret

calculate_result_matrix_size:
    sub rsp, 8          ;aligning the stack
    
    cmp qword[convolution_type], 1              ;comparing the variable 'convolution_type' with 1 and jumping to else if it is not equal to 1
    jne else
    mov rax, qword[matrix_size]                 ;calculating the result matrix size using rax ('result_matrix_size' = 'matrix_size' - 'kernel_size' + 1)
    sub rax, qword[kernel_size]
    inc rax
    mov qword[result_matrix_size], rax          
    imul rax, rax                               ;calculating the result matrix size squared and storing it in the variable 'result_matrix_size_squared' using imul instruction
    mov qword[result_matrix_size_squared], rax
    jmp end_if

    else:
    mov rax, qword[matrix_size]                 ;calculating the result matrix size using rax('result_matrix_size' = 'matrix_size')
    mov qword[result_matrix_size], rax
    imul rax, rax                               ;calculating the result matrix size squared and storing it in the variable 'result_matrix_size_squared' using imul instruction    
    mov qword[result_matrix_size_squared], rax

    end_if:
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

build_matrix2_for_convolution:
    sub rsp, 8          ;aligning the stack

    xor r13, r13        ;setting r13 to 0 using xor instruction      

    build_matrix2_loop:
        push qword[row]                         ;storing the values of variables 'row' and 'column' in order to restore them
        push qword[column]
        call adjust_coordinates                 ;calling adjust_coordinates subroutine to adjust the coordinates of the current entry

        cmp qword[convolution_type], 4          ;comparing the variable 'convolution_type' with 4 and jumping to transfer_entry it is not equal to 4
        jne transfer_entry
        cmp qword[out_of_matrix], 1             ;comparing the variable 'out_of_matrix' with 1 and jumping to transfer_entry it is not equal to 1
        jne transfer_entry
        mov dword[matrix2 + r13 * 4], 0         ;moving 0 to the current entry of matrix2
        jmp update_coordinates

        transfer_entry:
        mov rbx, qword[row]                     ;calculating the index of the current entry of matrix ('row' * 'matrix_size' + 'column')
        imul rbx, qword[matrix_size]
        add rbx, qword[column]

        mov ebx, dword[matrix + rbx * 4]        ;transfering the current entry of matrix to the same entry in matrix2 using ebx
        mov dword[matrix2 + r13 * 4], ebx 

        update_coordinates:
        pop qword[column]                       ;restoring the values of variable 'row' and 'column' from top of the stack
        pop qword[row]
        inc qword[column]                       ;updating the value of the current column
        mov rbx, qword[column]                  ;comparing 'column' - 'first_column_in_each_row' with the variable 'kernel_size' using rbx and updating the current row if they are equal
        sub rbx, qword[first_column_in_each_row]
        cmp rbx, qword[kernel_size]
        jne build_matrix2_loop_condition
        inc qword[row]                              ;updating the value of the current row
        mov rbx, qword[first_column_in_each_row]    ;transfering the variable 'first_column_in_each_row' to the variable 'column' using rbx
        mov qword[column], rbx

        build_matrix2_loop_condition:
        inc r13                                     ;updating the value of the counter (r13 register)    
        cmp r13, qword[kernel_size_squared]         ;comparing counter with 'kernel_size_squared' and jumping back to the start of loop if counter value is less than 'kernel_size_squared'
        jl build_matrix2_loop
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

adjust_coordinates:
    sub rsp, 8          ;aligning the stack

    ;adjust the coordinates if they aren't valid (at least one of them is negative ore is not less than matrix size) according to the chosen convolution type 
    mov qword[out_of_matrix], 0         ;moving 0 to the variable 'out_of_matrix'

    cmp qword[convolution_type], 3      ;comparing the variable 'convolution_type' with 3 and jumping to mirror_coordinates if it is equal to 3
    je mirror_coordinates

    cmp qword[row], 0                   ;comparing the variable 'row' with 0 and jumping to make_row_zero if it is less than 0
    jl make_row_zero
    mov rax, qword[matrix_size]         ;comparing the variable 'row' with 'matrix_size' and jumping to make_row_max if it is not less than 'matrix_size'
    cmp qword[row], rax
    jge make_row_max
    jmp adjust_column                   ;jumping to adjust_column

    make_row_zero:
    mov qword[out_of_matrix], 1         ;moving 1 to the variable 'out_of_matrix'
    mov qword[row], 0                   ;moving 0 to the variable 'row'    
    jmp adjust_column

    make_row_max:
    mov qword[out_of_matrix], 1         ;moving 1 to the variable 'out_of_matrix'
    mov qword[row], rax                 ;transfering the variable 'matrix_size' to the variable 'row' using rax
    dec qword[row]                      ;decreasing the variable 'row'

    adjust_column:
    cmp qword[column], 0                ;comparing the variable 'column' with 0 and jumping to make_column_zero if it is less than 0
    jl make_column_zero
    mov rax, qword[matrix_size]         ;comparing the variable 'column' with 'matrix_size' and jumping to make_column_max if it is not less than 'matrix_size'    
    cmp qword[column], rax
    jge make_column_max
    jmp adjust_coordinates_finish       ;jumping to adjust_coordinates_finish

    make_column_zero:
    mov qword[out_of_matrix], 1         ;moving 1 to the variable 'out_of_matrix'
    mov qword[column], 0                ;moving 0 to the variable 'column' 
    jmp adjust_coordinates_finish

    make_column_max:
    mov qword[out_of_matrix], 1         ;moving 1 to the variable 'out_of_matrix'
    mov qword[column], rax              ;transfering the variable 'matrix_size' to the variable 'column' using rax
    dec qword[column]                   ;decreasing the variable 'column'
    jmp adjust_coordinates_finish

    mirror_coordinates:
    cmp qword[row], 0                   ;comparing the variable 'row' with 0 and jumping to negative_row if it is less than 0 
    jl negative_row
    mov rax, qword[matrix_size]         ;comparing the variable 'row' with 'matrix_size' and jumping to positive_row if it is not less than 'matrix_size'
    cmp qword[row], rax
    jge positive_row
    jmp mirror_column                   ;jumping to mirror_column 

    negative_row:
    neg qword[row]                      ;negating the variable 'row'
    dec qword[row]                      ;decreasing the variable 'row'
    jmp mirror_column

    positive_row:
    mov rax, qword[matrix_size]         ;calculating the value 2 * 'matrix_size' - 'row' - 1 and storing it in the variable 'row' using rax
    sub rax, qword[row]
    dec rax
    add rax, qword[matrix_size]
    mov qword[row], rax

    mirror_column:
    cmp qword[column], 0                ;comparing the variable 'column' with 0 and jumping to negative_column if it is less than 0 
    jl negative_column
    mov rax, qword[matrix_size]         ;comparing the variable 'column' with 'matrix_size' and jumping to positive_column if it is not less than 'matrix_size'
    cmp qword[column], rax
    jge positive_column
    jmp adjust_coordinates_finish       ;jumping to adjust_coordinates_finish

    negative_column:
    neg qword[column]                   ;negating the variable 'column'
    dec qword[column]                   ;decreasing the variable 'column'
    jmp adjust_coordinates_finish

    positive_column:
    mov rax, qword[matrix_size]         ;calculating the value 2 * 'matrix_size' - 'column' - 1 and storing it in the variable 'column' using rax
    sub rax, qword[column]
    dec rax
    add rax, qword[matrix_size]
    mov qword[column], rax

    adjust_coordinates_finish:
    add rsp, 8              ;restoring the initial value of the stack pointer

ret

convolution_using_matrix_multiplication:
    sub rsp, 8              ;aligning the stack

    mov rax, qword[matrix_size]             ;calculating matrix size squared and 'k' using rax and imul instruction (k = 'matrix_size' ^ 2)
    imul rax, rax
    mov qword[matrix_size_squared], rax
    mov qword[k], rax

    mov rax, qword[matrix_size]             ;calculating the value of the variable 't', the number of matrix 'M' rows (t = 'matrix_size' - 'kernel_size' + 1) using rax
    sub rax, qword[kernel_size]
    inc rax
    mov qword[t], rax                       
    imul rax, rax                           ;calculating 't2' and 'n' using rax and imul instruction (n = t ^ 2)
    mov qword[t2], rax
    mov qword[n], rax                       

    mov qword[m], 1                         ;moving 1 to the variable 'm'

    mov rax, qword[matrix_size]             ;calculating the value of 'n2t' using rax and imul instruction
    imul rax, rax
    imul rax, qword[t]
    mov qword[n2t], rax

    mov qword[convolution_type], 1          ;setting convolution type to 1 (regular convolution)
    call calculate_result_matrix_size       ;calling calculate_result_matrix_size subroutine to calculate the size of the result matrix

    call construct_M                        ;calling construct_M  subroutine to calculate the entries of matrix 'M'
    call construct_v                        ;calling construct_v subroutine to calculate the entries of vector 'v'

    call multiply_matrices                  ;calling multiply_matrices subroutine to calculate the matrix product 'MvT' ordinary (without using simd)
    mov rbp, product_matrix                 ;moving product_matrix address to use it as an argument for transfer_to_result_matrix subroutine
    call transfer_to_result_matrix          ;calling transfer_to_result_matrix to transfer product matrix to result matrix

    add rsp, 8              ;restoring the initial value of the stack pointer

ret

construct_M:
    sub rsp, 8              ;aligning the stack   

    mov qword[min_non_zero_column], 0           ;moving 0 to the variable 'min_non_zero_column'

    mov rax, qword[matrix_size]                 ;calculating the first max_non_zero_column using rax and imul instruction('first max_non_zero_column' = 'matrix_size' * 'kernel_size') 
    imul rax, qword[kernel_size]
    mov qword[max_non_zero_column], rax

    mov qword[block_row], 0                     ;moving 0 to the variable 'block_row'
    xor r12, r12                                ;setting r12 to 0 using xor instruction
    xor r13, r13                                ;setting r13 to 0 using xor instruction
    xor r15, r15                                ;setting r15 to 0 using xor instruction

    construct_M_outer_loop:
        construct_M_inner_loop:
            mov r14, r12                                ;calculating the index of the current entry of matrix M using imul instruction (r12 * n2 + r13)
            imul r14, qword[matrix_size_squared]
            add r14, r13

            cmp r13, qword[min_non_zero_column]         ;checking if the current row is less than min_non_zero_column, then setting the current entry to 0 if the condition holds
            jl make_entry_zero
            cmp r13, qword[max_non_zero_column]         ;checking if the current row is not less than max_non_zero_column, then setting the current entry to 0 if the condition holds
            jge make_entry_zero

            mov rax, r13                                ;moving r13 to rax
            sub rax, qword[min_non_zero_column]         ;subtracting min_non_zero_column from rax
            mov rbx, qword[matrix_size]                 ;moving the variable 'matrix_size' to rbx
            xor rdx, rdx                                ;setting rdx to 0 using xor instruction
            idiv rbx                                    ;dividing rax by rbx ((r13 - 'min_non_zero_column') / 'matrix_size'). the quotient shows 'i' and the remainder shows the block column

            cmp rdx, qword[block_row]                   ;checking if the remainder (the column in this block) is less 'block_row', and setting the current entry to 0 if the condition holds
            jl make_entry_zero

            mov rbx, qword[kernel_size]                 ;checking if the remainder (the column in this block) is not less than 'block_row' + 'kernel_size', and setting the current entry to 0 if the condition holds
            add rbx, qword[block_row]
            cmp rdx, rbx
            jge make_entry_zero

            sub rdx, qword[block_row]                   ;calculating the index of the kernel entry that should be transfered to the current entry of matrix M ('block_row' * 'kernel_size' + rdx) 
            imul rax, qword[kernel_size]
            add rax, rdx
            mov ebx, dword[kernel + rax * 4]            ;transfering the entry of kernel ti the current entry of matrix M using ebx
            mov dword[matrix1 + r14 * 4], ebx
            jmp continue_loop

            make_entry_zero:
            mov dword[matrix1 + r14 * 4], 0             ;moving 0 to the current entry of matrix M

            continue_loop:
            inc r15                                     ;updating the counter (r15 register)
            cmp r15, qword[n2t]                         ;comparing counter with 'n2t'. then updating the value of variables 'min_non_zero_column' and 'max_non_zero_column' (increase them by 'matrix_size') and setting the counter to 0 if counter value is equal to 'n2t'
            jne construct_M_inner_loop_condition
            xor r15, r15                                ;setting r15 to 0 using xor instruction
            mov rax, qword[matrix_size]                 
            add qword[min_non_zero_column], rax         ;adding 'matrix_size' to both variables 'min_non_zero_column' and 'max_non_zero_column' using rax
            add qword[max_non_zero_column], rax

            construct_M_inner_loop_condition:
            inc r13                                     ;updating the value of the current column (r13 register)
            cmp r13, qword[matrix_size_squared]         ;comparing current column with 'matrix_size_squared' and jumping back to the start of inner loop if current column value is less than 'matrix_size_squared'
            jl construct_M_inner_loop

        inc qword[block_row]                            ;updating the value of the variable 'block_row'
        mov rax, qword[t]                               ;comparing the value of the variable 'block_row' with the variable 't' and setting the variable 'block_row' to 0 if they are equal
        cmp qword[block_row], rax                                   
        jne construct_M_outer_loop_condition
        mov qword[block_row], 0

        construct_M_outer_loop_condition:
        xor r13, r13                                
        inc r12                                         ;updating the value of the current row (r12 register)
        cmp r12, qword[t2]                              ;comparing current row with 't2' and jumping back to the start of outer loop if current row value is less than 't2'
        jl construct_M_outer_loop

    add rsp, 8              ;restoring the initial value of the stack pointer

ret

construct_v:
    sub rsp, 8              ;aligning the stack

    xor r12, r12            ;setting r12 to 0 using xor instruction

    construct_v_loop:               
        mov ebx, dword[matrix + r12 * 4]            ;transfering the current entry of matrix to the current entry of matrix2 using ebx
        mov dword[matrix2 + r12 * 4], ebx

        inc r12                                     ;updating the value of the counter (r12 register)    
        cmp r12, qword[matrix_size_squared]         ;comparing counter with 'matrix_size_squared' and jumping back to the start of loop if counter value is less than 'matrix_size_squared'
        jl construct_v_loop

    add rsp, 8              ;restoring the initial value of the stack pointer

ret

transfer_to_result_matrix:
    sub rsp, 8              ;aligning the stack

    xor r12, r12            ;setting r12 to 0 using xor instruction

    transfer_to_result_matrix_loop:
        mov ebx, dword[rbp + r12 * 4]                   ;transfering the current entry of matrix stored in rbp to the current entry of result_matrix using ebx
        mov dword[result_matrix + r12 * 4], ebx

        inc r12                                         ;updating the value of the counter (r12 register)          
        cmp r12, qword[result_matrix_size_squared]      ;comparing counter with 'result_matrix_size_squared' and jumping back to the start of loop if counter value is less than 'result_matrix_size_squared'
        jl transfer_to_result_matrix_loop

    add rsp, 8              ;restoring the initial value of the stack pointer

ret

read_matrix:
    sub rsp, 8          ;aligning the stack

    xor r12, r12        ;setting r12 to 0 using xor instruction
    
    read_matrix_loop:
        xor eax, eax        ;setting eax to 0 using xor instruction
        call read_float                 ;calling read_float subroutine to get the current entry of matrix from the user
        mov dword[rbp + r12 * 4], eax   ;moving eax to the current entry of the matrix    

        inc r12                     ;updating the value of the counter (r12 register)  
        cmp r12, r13                ;comparing counter with r13 and jumping back to the start of loop if counter value is less than r13
        jl read_matrix_loop
    
    call read_char
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

save_start_time:
    sub rsp, 8          ;aligning the stack

    rdtsc                           ;saving the current clock of computer in order to store it in rax and rdx
    mov [start_time_h],rdx          ;moving the high 4-bytes of clock which is in rdx to the variable 'start_time_h'
    mov [start_time_l],rax          ;moving the low 4-bytes of clock which is in rax to the variable 'start_time_l'

    add rsp, 8          ;restoring the initial value of the stack pointer

ret

calculate_execution_time:
    sub rsp, 8          ;aligning the stack

    rdtsc                               ;saving the current clock of computer in order to store it in rax and rdx
    mov [end_time_h], rdx               ;moving the high 4-bytes of clock which is in rdx to the variable 'end_time_h'
    mov [end_time_l], rax               ;moving the low 4-bytes of clock which is in rax to the variable 'end_time_l'
    mov rbx, [end_time_h]               ;moving the variable 'end_time_h' to rbx
    sub rbx, [start_time_h]             ;subtracting the variable 'start_time_h' from rbx 
    shl rbx, 32                         ;shifting rbx 32 bits to the left (multiplying rbx by 2 ^ 32)
    add rbx, [end_time_l]               ;adding the variable 'end_time_l' to rbx
    sub rbx, [start_time_l]             ;subtracting the variable 'start_time_l' from rbx (rbx = ('end_time_h' - 'start_time_h')*(2^32) + 'end_time_l' - 'start_time_l')
    mov rax, rbx                        ;dividing rbx by the clock rate of cpu
    imul rax, 10                        ;moving 10 * rbx to rax using imul instruction
    mov rbx, 30
    xor rdx, rdx
    idiv rbx                            ;dividing rbx by 3 and storing it in rax (my cpu is 3GHz)
    mov [execution_time],rax            ;moving execution time in nanoseconds to the varibale 'execution_time'

    add rsp, 8          ;restoring the initial value of the stack pointer

ret

print_matrix:
    sub rsp, 8          ;aligning the stack

    mov rax, r13                    ;calculating the number of matrix entries using imul instruction and storing it in the variable 'number_of_entries'
    imul rax, r14
    mov qword[number_of_entries], rax

    xor r12, r12                    ;setting r12 to 0 using xor instruction

    print_matrix_loop:
        mov edi, dword[rbp + r12 * 4]       ;printing the current entry of the matrix with a space character
        call print_float

        mov rdi, ' '
        call print_char
        
        inc r12                         ;updating the value of the counter (r12 register)  
        mov rax, r12                    ;moving r12 (counter) to rax
        xor rdx, rdx                        
        idiv r14                        ;dividing rax by r13 (matrix size) using idiv instruction
        cmp rdx, 0                      ;comparing the remainder with 0 and printing new line if it is equal to 0
        jne print_matrix_loop_condition
        call print_nl

        print_matrix_loop_condition:
        cmp r12, qword[number_of_entries]     ;comparing counter with 'number_of_entries' and jumping back to the start of loop if counter value is less than 'number_of_entries'
        jl print_matrix_loop
    
    add rsp, 8          ;restoring the initial value of the stack pointer

ret

extract_int:
    sub rsp, 8          ;aligning the stack              

    xor rbx, rbx        ;setting rbx to 0 using xor instruction
    xor r15, r15        ;setting r15 to 0 using xor instruction

    extract_int_loop:
        call read_char                  ;calling read_char subroutine to input a character from the user

        cmp rax, 10                     ;comparing rax with 10 (new line character) and jumping to extract_int_after_loop if it is equal to 10
        je extract_int_after_loop
        cmp rax, '0'                    ;comparing rax with 0 character and jumping to invalid_input_entered if it is less than 0
        jl invalid_input_entered
        cmp rax, '9'                    ;comparing rax with 9 character and jumping to invalid_input_entered if it is greater than 9
        jg invalid_input_entered
        sub rax, 48                     ;subtracting 48 (assci code of character 0) from rax to store the digit value in it
        imul rbx, 10                    ;multiplying the current value of rbx by 10 and adding the next digit (stored in rax) to it (rbx = 10 * rbx + rax)
        add rbx, rax
        jmp extract_int_loop

        invalid_input_entered:
        mov r15, 1                      ;moving 1 to r15 to show that the user has entered an invalid nondigit character
        jmp extract_int_loop
        
    extract_int_after_loop:
    cmp r15, 1                          ;comparing r15 with 1 and jumping to invalid_input if it is equal to 1
    je invalid_input
    mov rax, rbx                        ;moving the number stored in rbx to rax
    jmp extract_int_finish

    invalid_input:
    mov rax, 1000000                    ;moving 1000000 to rax (1000000 is the code for invalid input)

    extract_int_finish:
    add rsp, 8          ;restoring the initial value of the stack pointer

ret





