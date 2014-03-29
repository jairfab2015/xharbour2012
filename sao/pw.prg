Select 1
   Use apoio index apoio 
codpw = space(5)
set message to 24
public espaco,nivelx,vcodi,dianov,quebra1
inseri = .t.
SNA = .t.
conttent = 0
do while SNA
   inseri = .t.
   @ 11,24 say "Staff....:" get codpw pict "@R 99.999"
   @ 14,24 say "Password.:"
   @ 14,35 say replicate (Chr(95),06)
   READ //()
   @ 20,04 say espaco
   vcodi = codpw
   if codpw = space(5)
       Mensagem("Nao aceito Staff em branco, sr. operador !",8,1)
      inkey(4)
      loop
    endif
    seek  codpw 
    if .not. found()
       Mensagem("Usuario nao cadastrado, acesso bloqueado !",8,1)
       conttent = conttent + 1
       quebra = 1
       inkey(4)
       codpw = space(5)
       loop
    endif
    codacesx:=codaces
    do while inseri
       pw1:=pw2:=pw3:=pw4:=pw5:=pw6:=Space(1)
       set color to w/n,n/n
       cols = 35
       contador = 1
       do while contador <= 6
          varia = "pw" + ltrim(str(contador))
          @ 14,cols get &varia
          read
          if &varia = space(01)
             Mensagem("Nao aceito password com espaco em branco... !",8,1)
             inkey(4)
             loop
          endif
          if contador = 1
             stor isalpha(&varia) to posicao
             if posicao = .f.
                  Mensagem("Nao aceito password iniciada em numeros, sr. operador !",8,1)
                  inkey(4)
                  loop
             endif
          endif
          @ 14,cols say "*"
          if lastkey() = 08
             cols = cols - 1
             contador = contador - 1
             loop
             else
                cols = cols + 1
                contador = contador + 1
                loop
          endif
       enddo
       pwe = pw1 + pw2 + pw3 + pw4 + pw5 + pw6
       pw = rtrim(pwe)
       exit
    enddo
    set color to w/n,n/w
    password = uppe(pw)
    select 1
        set exact on
    locate for codpw = nome
    stor codaces to codacesx
    if password # codaces
       set exact off
       Mensagem("Password nao reconhecida, acesso bloqueado... !",8,1)
       conttent = conttent + 1
       quebra = 2
       inkey(4)
       loop
    endif
    conttent = 0
    public nivelx
    stor nivacess to nivelx
    goto bott
    regcon = recno()
    public regsenha
    regsenha = recno()
    if nivelx >= 100
       setcancel(.T.)
    endif
    use
    SNA = .f.
enddo
