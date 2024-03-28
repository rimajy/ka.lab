.model small
.stack 100h

.data
buffer  db 255 dup(?)  ; буфер для зберігання введених даних
numbers dw 10000 dup(?) ; масив для зберігання чисел

.code
start:
    mov ax, @data
    mov ds, ax

    mov cx, 0  ; лічильник чисел

read_loop:
    mov ah, 3Fh       ; зчитування з stdin
    mov bx, 0         ; stdin handle
    mov cx, 255       ; максимальна довжина рядка
    lea dx, buffer    ; буфер для зберігання рядка
    int 21h

    mov si, offset buffer  ; si вказує на початок рядка

parse_loop:
    mov bl, [si]      ; завантаження символу
    cmp bl, ' '       ; перевірка на пробіл
    je add_number     ; якщо пробіл, перейти до додавання числа

    cmp bl, 0         ; перевірка на кінець рядка
    je add_number     ; якщо кінець рядка, перейти до додавання числа

    sub bl, '0'       ; конвертація символу у число
    mov cx, ax        ; зберігаємо ax у cx
    shl ax, 1         ; множення ax на 10
    add ax, cx        ; додавання нової цифри
    add ax, ax        ; множення на 2 для ефективності (ax = ax * 10)
    add ax, bx        ; додавання цифри до ax

    inc si            ; перехід до наступного символу
    jmp parse_loop    ; повторення парсингу

add_number:
    mov bx, cx          ; поміщаємо значення cx до bx для обчислення зміщення
    shl bx, 1           ; масштабування bx на 2, оскільки кожне число двобайтове

    lea di, numbers     ; завантаження адреси масиву numbers до регістра di
    mov [di + bx], ax   ; збереження числа в масиві з обчисленим зміщенням

    ; Перевірка на від'ємне число
    mov ax, [di + bx]   ; Завантажуємо число до ax
    test ax, 8000h      ; Перевіряємо найстарший біт
    jnz negative_number ; Якщо найстарший біт встановлений (від'ємне число), переходимо до negative_number

    inc cx                      ; збільшення лічильника чисел

    cmp bl, 0         ; перевірка на кінець вводу
    je sort_numbers    ; якщо кінець вводу, переходимо до сортування чисел

    jmp read_loop      ; повторення зчитування

negative_number:
    ; Конвертуємо від'ємне число в його двійкове представлення у вигляді доповнювального коду
    neg ax             ; Від'ємне число: беремо доповнення до двійки
    not ax             ; Перевертаємо всі біти

    ; Від'ємне число в доповнювальному коді зберігається в [di + bx]

    inc cx             ; збільшення лічильника чисел

    cmp bl, 0         ; перевірка на кінець вводу
    je sort_numbers    ; якщо кінець вводу, переходимо до сортування чисел

    jmp read_loop      ; повторення зчитування

sort_numbers:
    ; Сортування чисел
    mov cx, word ptr cx     ; Завантажуємо кількість чисел до cx
    dec cx                  ; count-1
outerLoop:
    push cx
    lea si, numbers
innerLoop:
    mov ax, [si]
    cmp ax, [si+2]
    jl nextStep
    xchg [si+2], ax
    mov [si], ax
nextStep:
    add si, 2
    loop innerLoop
    pop cx
    loop outerLoop
 
end_program:
    mov ah, 4Ch        ; вихід з програми
    int 21h
end start









