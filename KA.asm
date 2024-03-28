.model small
.stack 100h

.data
oneChar db ?
currentLine db 100 dup(?) 
.code
main:
    mov ax, @data
    mov ds, ax

read_next:
    mov ah, 3Fh       
    mov bx, 0         
    mov cx, 1        
    mov dx, offset oneChar 
    int 21h           

    or ax, ax         
    jz read_end      

    mov al, [oneChar] 
    mov [currentLine + si], al 

    mov dl, [currentLine + si]        
    mov ah, 02h                      
    int 21h                           

    inc si 

    cmp al, 0Ah      
    jz find_string_count_preparation       

    jmp read_next     

read_end:
    mov ah, 4Ch       
    int 21h           

find_string_count_preparation:
    jmp read_next   

end main





