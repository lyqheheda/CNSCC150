; assembler frame 
; ring and print a message per 3 seconds 
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

; get the old interrupt vector…… 
mov ah, 35h
mov al, 1ch
int 21h
mov word ptr old,bx
mov word ptr old+2, es

;----------------------注册
mov dx,cs      ;move the address of code segment(basic address of new procedure) to ds
mov ds,dx  

 ;install the new interrupt vector 
mov dx, offset ring
mov ah,25h
mov al,1ch
int 21h
;------------------------注册结束

;-------------把ds换回来，下面还要用data里的字符串，这个好像有可能在之这句之前就调用了1ch，有风险，是不是放在ISR里边更好？
mov ax,data;the ds is changed by previous line, now set back to get the datas
mov ds,ax

; delay some time for printing and ringing 
mov cx, count




;restore the old interrupt vector 

mov ah,0;等待键盘输入
int 16h


; return to DOS 

;主程序结束语句好像是应该放在这里，标志主程序结束，其他函数的代码放在主程序外面
mov ah,4ch; end program
int 21h





; ---------------------------------ring and print procedure 
ring proc near 
; ISR
; 猜想：每秒自动被调用18.2次， 那么将一个寄存器设为0，每次被调用+1， 如果被调用54次则打印；
; 试验：若猜想正确，重写使每次被调用则打印，那么屏幕应该每秒有18条字符串被打印
inc cx



cmp cx, 18
jge close

continue:


cmp cx, 54
jne skip

lea dx, message
mov ah,9
int 21h
mov cx, 1

;-----------------------ring
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

;delay



skip:
iret 


close:
in al,61h
and al,0fch
out 61h,al
jmp continue

ring endp 
;--------------------------end of ring procedure


code ends 
end start 