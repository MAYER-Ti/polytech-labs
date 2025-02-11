.model	tiny ; huge
.stack	100h
.data
      baseMes DB 'Model: ', '$'
      mesTiny DB 'Tiny', '$'
      mesOther DB 'Other', '$'
      newline DB 0Dh, 0Ah, '$'
.code
start:
      mov ax,@data
      mov ds,ax

      ; в tiny вся программа в одном сегменте
      mov bx, cs
      cmp ax, bx
      je printTiny
      
      
      jne printOther
      ; в small код и данные находятся в разных сегментах
      ; в medium данные в одном сегменте, а код разделен на несколько сегментов

      ; в compact код находится в одном сегменте, 
      ; а данные могут быть разделены на несколько сегментов

      ; в large код и данные могут занимать несколько сегментов, 
      ; можно использовать до 1 МБ

      ; в huge как в large, только размеры сегментов данных больше 
      ; (превышают 64 КБ)


      
printTiny:
      lea dx, baseMes
      mov ah, 09h
      int 21h             
      lea dx, mesTiny
      int 21h             
      jmp finish 
 
printOther:
      lea dx, baseMes
      mov ah, 09h
      int 21h             
      lea dx, mesOther
      int 21h             
  
finish:
      lea dx, newline
      int 21h      
      mov ax,4c00h
      int 21h
      
end	start