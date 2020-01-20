org 07C00h
main:
        jmp short main1
        db 60 dup (90h)
main1:  mov ax,3        ;�-� ��������� ���������� �����������
        int 10h         ;���������� ��������� ����������
        mov ax,cs
        mov ds,ax
        mov si,msg1     ;���������
        mov dh,1       ;x 1-�� ���������
        mov dl,21       ;y 1-�� ���������
        mov ah,6        ;����
        call printtext  ;������� ���������
        mov si,msg2     ;���������
        mov dh,4       ;x 2-�� ���������
        mov dl,22      ;y 2-�� ���������
        mov ah,8       ;����
        call printtext  ;������� ���������

        mov al,0dbh     ;��� �������
        mov ah,4        ;����
        mov dh,64        ;��������� � ������
        mov dl,2       ;��������� y ������
        mov cx,1        ;������� �������� �������� �� �����������
lp2:    push cx         ;��������� ��������
        push dx 
lp1:    call printchar  ;������� ������
        inc dh          ;���������� ������
        loop lp1        ;������� ��� ������
        pop dx          ;������������ ��������
        pop cx
        sub dh,1        ;������ ��������� ������ �� 4 ������� �����
        add cx,2        ;� ������ �� 8 �������� ������
        inc dl          ;������� �� ��������� ������ ������
        cmp dl,11       ;���� �� �������� �������� ������
        jnz lp2         ;����������
;���������� ���������
        cli
        hlt

;��������� ������ ������ �� �����
;ds:si - ASCII-������
;ah-��������
;dh - x
;dl - y
printtext:
        cld
prtlp:  lodsb           ;������ �����
        test al,al      ;���� 0
        jz prtex        ;�� ��������� �����
        call printchar  ;������� �����
        inc dh          ;��������� ������
        jmp prtlp       ;���������� �����
prtex:  ret             ;����� �� ������������
;��������� ������ ������� �� �����
;al - ������
;ah-��������
;dh - x
;dl - y
printchar:
        push es         ;��������� ��������
        push bx
        push dx
        push 0b800h     ;����������� ���������� ������� �� �����������
        pop es
vyv:    push dx         ;��������� ���������� ������
;�������� � �������� �������� ������������� ���: dl(y)*80(���-�� ��������)*2(��� ����� �� ������) + dh(x)*2(��� ����� �� ������)
        xor dh,dh       ;�������� ������� ����� dx
        shl dx,5        ;�������� dx �� 32
        mov bx,dx       ;��������� y*32
        shl dx,2        ;�������� ��� �� 4(y*128)
        add bx,dx       ;y*160 (y*32+y*128=y*160)
        pop dx          ;��������������� ����������
        mov dl,dh       ;x �������� � dl
        xor dh,dh       ;�������� ������� ����� dx
        shl dx,1        ;x*2
        add bx,dx       ;������������ ����������� ����� ������� � �����������
        mov [es:bx],ax  ;������� �� �����(����� � �������� ������)
        pop dx          ;��������������� ��������
        pop bx
        pop es
        ret             ;����� �� ������������
; ������
msg1 db 'Asabin Konstantin',0
msg2 db 'NMT-373907',0

; ��� ��������� ���������� ���������� ��������� ���������� ����� ������ (�� 510-� ����)
times 510-($-main) db 0
; � ��� ��� ����� ����� ����� ���� ��������� ��� ��� ������������� ��� ������
dw 0xAA55
