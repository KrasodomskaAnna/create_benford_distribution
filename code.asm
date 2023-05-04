x86asm
.686
.model flat
extern _VirtualAlloc@16    : PROC
public _create_benford_distribution_asm

.code
_create_benford_distribution_asm PROC
    push ebp
    mov ebp, esp
    
    push ebx
    push esi
    push edi
    
    ; alokacja pamięci
    push dword PTR 1
    push dword PTR 1000h
    ; float to 32 bit
    ; czyli rozmiar 32/8 = 4B
    ; musimy obliczyć dla cyfr 1, ..., 9 -> 9 cyfr
    ; czyli 4(float) * 9 (cyfr) = 36B
    push dword PTR 4*9
    push dword PTR 0
    call _VirtualAlloc@16
    ; eax := adres przydzielonej pamięci
    
    ; for(ecx := 1; ecx <= 9; ecx++){
    ;         oblicz Pk
    ;         wrzuć do przydzielonej pamięci
    ; }
    finit
    mov ecx, 1
    ptl:
        ; oblicz Pk
        fld1
        push ecx
        fild dword PTR [esp]            ; wrzuć k
        add esp, 4
        ; st(0) := k, st(1) := 1
        fdivp        ; st(0) := 1/k
        
        fld1
        faddp        ; st(0) := 1 + 1/k = X
        
        fld1        ; 1, X
        fxch        ; X, 1
        
        fyl2x        ; log2(X) *1
        
        ; log10(X) = log2(X) / log2(10)
        ; wyznaczenie log2(10)
        fld1
        push dword PTR 10
        fild dword PTR [esp]
        add esp, 4        ; 1, 10, log2(X)
        
        fyl2x            ; log2(10), log2(X)
        fdivp            ; st(0) := log2(X) / log2(10)
        
        ; wrzucenie do przydzielonej pamięci
        fstp dword PTR [eax+ecx*4-4]
        
        ; sterowanie forem
        inc ecx
        cmp ecx, 9
        jna ptl
    
    pop edi
    pop esi
    pop ebx
    
    pop ebp
    ret
_create_benford_distribution_asm ENDP
end