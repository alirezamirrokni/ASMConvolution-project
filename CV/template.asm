;Student: Alireza Mirrokni (student number: 401106617)
;Instructor: Prof. Jahangir
;Sharif University Of Technology
;Winter 2024
;Description: this is an assembly program to proccess an image using 2-D convolution

%include "asm_io.inc"

section .data
    ;VARIABLES
    ;defining the variables needed for saving values
    matrix1: times 1000000 dd 0
    matrix2: times 1000000 dd 0
    sum: dd 0.0
    kernel: times 1000000 dd 0
    kernel_size: dq 0
    kernel_size_squared: dq 0
    r: times 1000000 dd 0
    g: times 1000000 dd 0
    b: times 1000000 dd 0
    matrix_size: dq 0
    r_result: times 1000000 dd 0
    g_result: times 1000000 dd 0
    b_result: times 1000000 dd 0
    result_matrix_size: dq 0
    result_matrix_size_squared: dq 0
    row: dq 0
    column: dq 0
    first_column_in_each_row: dq 0
    number_of_entries: dq 0
    max_iter: dq 0
    max_index: dq 0
    min_index: dq 0
    number_of_matrix1_entries: dq 0
    input_kernel: dq 1

segment .text
    global asm_main                         
    global read_matrix                      
    global print_matrix                     
    extern printf                            

asm_main:
	push rbp            
    push rbx            
    push r12            
    push r13            
    push r14            
    push r15           

    sub rsp, 8          

    call read_int
    mov qword[kernel_size], rax
    mov qword[input_kernel], 1
    imul rax, rax
    mov r13, rax
    mov rbp, kernel
    call read_matrix

    call read_int
    mov qword[matrix_size], rax
    mov qword[input_kernel], 0 
    imul rax, rax
    mov r13, rax
    mov rbp, r
    call read_matrix

    mov rbp, g
    call read_matrix

    mov rbp, b
    call read_matrix

    mov rbp, r
    mov r15, r_result
    call edge_handling_convolution

    mov rbp, g
    mov r15, g_result
    call edge_handling_convolution

    mov rbp, b
    mov r15, b_result
    call edge_handling_convolution

    mov r14, qword[result_matrix_size]
    mov r13, qword[result_matrix_size]
    mov rbp, r_result
    call print_matrix

    mov rbp, g_result
    call print_matrix

    mov rbp, b_result
    call print_matrix

    add rsp, 8          

	pop r15             
	pop r14             
	pop r13             
	pop r12             
    pop rbx             
    pop rbp             

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

            call multiply_entries                       ;calling multiply_entries to calculate the dot product of 2 matrices without using simd
            mov ebx, dword[sum]                         ;transfering the variable 'sum' to the current entry of result_matrix using ebx
            mov dword[r15 + r14 * 4], ebx

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
    
    mov rax, qword[matrix_size]                 ;calculating the result matrix size using rax('result_matrix_size' = 'matrix_size')
    mov qword[result_matrix_size], rax
    imul rax, rax                               ;calculating the result matrix size squared and storing it in the variable 'result_matrix_size_squared' using imul instruction    
    mov qword[result_matrix_size_squared], rax

    add rsp, 8          ;restoring the initial value of the stack pointer

ret

build_matrix2_for_convolution:
    sub rsp, 8          ;aligning the stack

    xor r13, r13        ;setting r13 to 0 using xor instruction      

    build_matrix2_loop:
        push qword[row]                         ;storing the values of variables 'row' and 'column' in order to restore them
        push qword[column]
        call adjust_coordinates                 ;calling adjust_coordinates subroutine to adjust the coordinates of the current entry

        transfer_entry:
        mov rbx, qword[row]                     ;calculating the index of the current entry of matrix ('row' * 'matrix_size' + 'column')
        imul rbx, qword[matrix_size]
        add rbx, qword[column]

        mov ebx, dword[rbp + rbx * 4]        ;transfering the current entry of matrix to the same entry in matrix2 using ebx
        mov dword[matrix2 + r13 * 4], ebx 

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
    cmp qword[row], 0                   ;comparing the variable 'row' with 0 and jumping to make_row_zero if it is less than 0
    jl make_row_zero
    mov rax, qword[matrix_size]         ;comparing the variable 'row' with 'matrix_size' and jumping to make_row_max if it is not less than 'matrix_size'
    cmp qword[row], rax
    jge make_row_max
    jmp adjust_column                   ;jumping to adjust_column

    make_row_zero:
    mov qword[row], 0                   ;moving 0 to the variable 'row'    
    jmp adjust_column

    make_row_max:
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
    mov qword[column], 0                ;moving 0 to the variable 'column' 
    jmp adjust_coordinates_finish

    make_column_max:
    mov qword[column], rax              ;transfering the variable 'matrix_size' to the variable 'column' using rax
    dec qword[column]                   ;decreasing the variable 'column'

    adjust_coordinates_finish:
    add rsp, 8              ;restoring the initial value of the stack pointer

ret

read_matrix:
    sub rsp, 8          ;aligning the stack

    xor r12, r12        ;setting r12 to 0 using xor instruction

    cmp qword[input_kernel], 0
    jne else
    read_matrix_loop1:
        call read_float                 ;calling read_float subroutine to get the current entry of matrix from the user
        mov dword[rbp + r12 * 4], eax     ;moving eax to the current entry of the matrix 

        inc r12                     ;updating the value of the counter (r12 register)  
        cmp r12, r13                ;comparing counter with r13 and jumping back to the start of loop if counter value is less than r13
        jl read_matrix_loop1
    jmp end_if

    else:
    read_matrix_loop2:
        call read_float                 ;calling read_float subroutine to get the current entry of matrix from the user
        mov dword[kernel + r12 * 4], eax     ;moving eax to the current entry of the matrix 
    
        inc r12                     ;updating the value of the counter (r12 register)  
        cmp r12, r13                ;comparing counter with r13 and jumping back to the start of loop if counter value is less than r13
        jl read_matrix_loop2
    
    end_if:
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



