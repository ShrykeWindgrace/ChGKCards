\ProvidesClass{chgkcard}[2015/08/31 v0.1 class for creating ChGK tournaments blanks]
\RequirePackage{kvoptions}%to process keyval options
\RequirePackage{iftex}%detect the engine
\DeclareStringOption[4]{teams}
\DeclareStringOption[37]{questions}
\DeclareBoolOption{printreserve}
\DeclareBoolOption[true]{printteamsatall}
\DeclareBoolOption[true]{printquestions}
\DeclareBoolOption{printreserveteamnumbers}
\ProcessKeyvalOptions*
\LoadClass[a4paper, 12pt]{article}
\ifXeTeX
	\RequirePackage{fontspec}
\else
	\RequirePackage[utf8]{inputenc}
	\RequirePackage[T2A]{fontenc}
\fi
\RequirePackage[russian]{babel}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage[nomessages]{fp}
\RequirePackage{forloop}
\RequirePackage{etoolbox}
\geometry{
	total={210mm,297mm},
	left=0mm,
	% right=0mm,
	% top=0mm,
	bottom=0mm,
}
\topskip0pt

\newcommand{\blNew}[2]{\noindent\fbox{\begin{minipage}[t][71.5mm][t]{50mm}\rotatebox[origin=rb]{90}{Вопрос:~#2}\vfill\rotatebox{90}{Команда:~#1}\end{minipage}}}%a card

\newcommand{\totalteamsPO}{\chgkcard@teams}% total number of questions +1
% \newcommand{\totalteamsPR}{3}% total number of questions
\newcommand{\totalquestsPO}{\chgkcard@questions}% total number of questions+1
% \newcommand{\totalquestsPR}{36}% total number of questions
% \newcommand{\totalreservePO}{4}% total number of reserve blanks per team

\newtoggle{printreserveinner}%by default we do not print reserve cards
\ifchgkcard@printreserve\toggletrue{printreserveinner}\else\togglefalse{printreserveinner}\fi

\newtoggle{printteamsatallinner}%by default we print team numbers
\ifchgkcard@printteamsatall\toggletrue{printteamsatallinner}\else\togglefalse{printteamsatallinner}\fi

\newtoggle{printquestionsinner}%by default we print question numbers
\ifchgkcard@printquestions\toggletrue{printquestionsinner}\else\togglefalse{printquestionsinner}\fi

\newtoggle{printreserveteamnumbersinner} %has no effect if printreserve==false. 
%by default we do not print numbers on reserve cards
\ifchgkcard@printreserveteamnumbers\toggletrue{printreserveteamnumbersinner}\else\togglefalse{printreserveteamnumbersinner}\fi

\newcommand{\teamoutput}{\iftoggle{printteamsatallinner}{\theteams}{}}
\newcommand{\questoutput}{\iftoggle{printquestionsinner}{\thequest}{}}

\newcommand{\printblancs}{\ifXeTeX\setmainfont{Lucida Console}\else\fi%
% \FPupn{totalteamsPOne}{8 1 +}%
% \FPeval{\totalquestsPO}{\totalquests+1}%
\newcounter{teams}%number of teams
\newcounter{quest}%questions
\newcounter{reserve}%number of additional blanks; printed without question numbers
\newcounter{stepTZ}
\setcounter{stepTZ}{0}
%NB! some printers like to add margins, so the final view will not be exactly the same as in preview
\noindent\forloop{teams}{1}{\value{teams}<\totalteamsPO}{\noindent\forloop{quest}{1}{\value{quest}<\totalquestsPO}{\blNew{\teamoutput}{\questoutput}\stepcounter{stepTZ}\FPeval{\resu}{trunc(\thestepTZ-(4*trunc(\thestepTZ/4,0)),0)}\FPifeq{\resu}{0}{\newline}\else{}\fi}}\iftoggle{printreserveinner}{\newline\noindent\forloop{teams}{1}{\value{teams}<\totalteamsPO}{\forloop{reserve}{0}{\value{reserve}<4}{\blNew{\iftoggle{printreserveteamnumbersinner}{\theteams}{}}{}}\newline}}{}}

\AtBeginDocument{\printblancs}

