# ChGKCards
Создание заготовки карточек ответов для турниров ЧГК средствами `LaTeX`.

## Использование

Пример кода для четырёх команд для пакета из 36 вопросов, запасные бланки - печатать, по два на команду

```
\documentclass[teams=6, questions=36, printreserve, reserve=2]{chgkcard}
\begin{document}
\end{document}
```

Компилировать можно при помощи `xelatex` (возможно, потребуется шрифт `Lucida Console`) и `pdflatex` (должно сработать и так).
