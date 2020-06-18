;***********************************************************************************************
;*                                                                                             *
;*                 Project Name : ring and print a message per 3 seconds                       *
;*                                                                                             *
;*                    File Name : ring.asm                                                     *
;*                                                                                             *
;*                   Programmer : Lin Yunqi                                                    *
;*                                                                                             *
;*                   Student ID : 18722016                                                     *
;*                                                                                             *
;*                  Last Update : 2020/6/18                                                    *
;*                                                                                             *
;*---------------------------------------------------------------------------------------------*

; assembler frame 

stack segment 
db  128 dup(0) 
stack ends 

data segment 
count dw 1 
message db   'bell ring', 0dh,0ah,'$' 
old dd ?
freg  dw 1989
data ends 

code segment 
assume ds:data, cs:code, ss:stack
start: 
mov ax, data
mov ds, ax

;----------get the old interrupt vector
mov ah, 35h
mov al, 1ch
int 21h
mov word ptr old,bx
mov word ptr old+2, es

;move the address of code segment(basic address of new procedure) to ds
mov dx,cs      
mov ds,dx  

;----------install the new interrupt vector 
mov dx, offset ring
mov ah,25h
mov al,1ch
int 21h

;the ds is changed by previous line, now set back to get the datas
mov ax,data
mov ds,ax

;accumulator used for time delay.
mov cx, count

;wait for keyboard input
mov ah,0
int 16h

;----------restore the old interrupt vector
mov dx,word ptr old+2
mov ds,dx
mov dx,word ptr old
mov ah,25h
mov al,1ch
int 21h

;----------return to DOS 
; end program
mov ah,4ch
int 21h

;----------ring and print procedure 
ring proc near 
; ISR
inc cx

;turn off the sound if it lasts for a second
cmp cx, 18
jge close
continue:

;----------delay some time for printing and ringing 
cmp cx, 54
jne skip

lea dx, message
mov ah,9
int 21h
mov cx, 1

;ring the bell
in al,61h
or al,3
out 61h,al

mov al,0b6h
out 43h,al

mov bx,freg
mov al,bl
out 42h,al
mov al,bh
out 42h,al

skip:
iret 

close:
in al,61h
and al,0fch
out 61h,al
jmp continue

ring endp 
;end of ring procedure

code ends 
end start 