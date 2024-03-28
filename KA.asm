.model small
.stack 100h

.data
buffer db 10000 dup(?)   ; буфер для зберігання введених даних
count dw 0               ; лічильник зчитаних символів

.code
main:
    mov ax, @data
    mov ds, ax

read_next:
    mov ah, 3Fh          ; DOS: читання з файлу
    mov bx, 0            ; буфер вводу (stdin)
    mov cx, 1            ; читати 1 байт
    mov dx, offset buffer ; адреса буфера
    int 21h              ; виклик DOS

    test ax, ax          ; перевірка на кінець файлу
    jz end_program

    mov al, buffer[0]    ; перший байт у AL

    ; перевірка на кінець рядка
    cmp al, 0Dh          ; CR
    je skip_next_byte    ; перевірка наступного байту
    cmp al, 0Ah          ; LF
    je skip_next_byte    ; перевірка наступного байту

    ; тут можна додати обробку кожного зчитаного символу
    ; наприклад, зберігання у буфері для подальшого аналізу

    inc count             ; збільшуємо лічильник зчитаних символів
    ; тут можна здійснити перевірку на максимальну довжину рядка

skip_next_byte:
    cmp count, 10000     ; перевірка на максимальну кількість символів
    jge end_program      ; якщо досягнуто, завершуємо програму

    jmp read_next        ; переходимо до наступного зчитування

end_program:
    mov ah, 4Ch          ; DOS: вихід з програми
    int 21h

end main





