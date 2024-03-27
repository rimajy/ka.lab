.model small
.stack 100h

.data
    buffer db 255 dup(?)    ; Буфер для зберігання введеного рядка
    oneChar db ?
    numbers dw 10000 dup(?) ; Масив для зберігання введених чисел
    numbersCount dw 0        ; Лічильник введених чисел

.code
main:
    mov ax, @data
    mov ds, ax

read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next

    ; Перевірка, чи досягнуто кінця файлу
    cmp ax, 0
    je end_of_input

    ; Перевірка, чи прочитаний символ - пробіл або перенос рядка
    mov al, oneChar
    cmp al, ' '
    je skip_space_or_newline
    cmp al, 0Dh
    je skip_space_or_newline
    cmp al, 0Ah
    je skip_space_or_newline

    ; Число зчитане, зберігаємо його у буфері та збільшуємо лічильник
    mov [buffer], al
    inc buffer
    jmp read_next

skip_space_or_newline:
    ; Перевірка, чи не пустий буфер
    cmp buffer, 0
    je read_next

    ; Конвертація числа з ASCII в двійковий формат та зберігання його у масиві чисел
    mov ax, buffer
    mov bx, 10
    xor cx, cx
convert_loop:
    mov dx, 0
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_loop
store_number:
    pop ax
    sub al, 30h   ; Конвертація ASCII у двійкове число
    mov [numbers + numbersCount], ax
    inc numbersCount
    loop store_number

    ; Очищення буфера та перехід до наступного символу
    mov buffer, 0
    jmp read_next

end_of_input:
    ; Обробка введених чисел
    ; Наприклад, можна вивести їх на екран
    mov cx, numbersCount
    mov si, offset numbers
print_numbers_loop:
    mov ax, [si]
    call print_number
    add si, 2
    loop print_numbers_loop

exit_program:
    mov ah, 4Ch              ; Завершення програми
    int 21h

print_number proc
    ; Виведення числа з ax на екран
    mov bx, 10
    xor dx, dx
    mov cx, 0
print_digit_loop:
    div bx
    push dx
    inc cx
    test ax, ax
    jnz print_digit_loop
print_loop:
    pop dx
    add dl, 30h              ; Конвертація числа у ASCII
    mov ah, 02h              ; Вивід символа
    int 21h
    loop print_loop
    ret
print_number endp
end main
