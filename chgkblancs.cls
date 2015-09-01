\ProvidesClass{chgkblancs}[2015/08/31 v0.1 class for creating ChGK tournaments blanks]
\RequirePackage{kvoptions}
\RequirePackage{iftex}
\DeclareStringOption[4]{teams}
\DeclareStringOption[13]{quests}
\DeclareBoolOption{printreserve}
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

\newcommand{\blNew}[2]{\noindent\fbox{\begin{minipage}[t][71.5mm][t]{50mm}\rotatebox[origin=rb]{90}{Вопрос:~#2}\vfill\rotatebox{90}{Команда:~#1}\end{minipage}}}%

\newcommand{\totalteamsPO}{\chgkblancs@teams}% total number of questions +1
% \newcommand{\totalteamsPR}{3}% total number of questions
\newcommand{\totalquestsPO}{\chgkblancs@quests}% total number of questions+1
% \newcommand{\totalquestsPR}{36}% total number of questions
% \newcommand{\totalreservePO}{4}% total number of reserve blanks per team

\newtoggle{printreserveinner}
\togglefalse{printreserveinner}
\ifchgkblancs@printreserve\toggletrue{printreserveinner}\else\fi
\newtoggle{printreserveteamnumbersinner} %has no effect if printreserve==false. 
\togglefalse{printreserveteamnumbersinner}
\ifchgkblancs@printreserveteamnumbers\toggletrue{printreserveteamnumbersinner}\else\fi
% \toggletrue{printreserveTeamNumbers} %uncomment this line if you want to print team numbers on reserve blanks
\newcommand{\printblancs}{\ifXeTeX\setmainfont{Lucida Console}\else\fi%
% \FPupn{totalteamsPOne}{8 1 +}%
% \FPeval{\totalquestsPO}{\totalquests+1}%
\newcounter{teams}%number of teams
\newcounter{quest}%questions
\newcounter{reserve}%number of additional blanks; printed without question numbers
\newcounter{stepTZ}
\setcounter{stepTZ}{0}
%NB! some printers like to add margins, so the final view will not be exactly the same as in preview
\noindent\forloop{teams}{1}{\value{teams}<\totalteamsPO}{\noindent\forloop{quest}{1}{\value{quest}<\totalquestsPO}{\blNew{\theteams}{\thequest}\stepcounter{stepTZ}\FPeval{\resu}{trunc(\thestepTZ-(4*trunc(\thestepTZ/4,0)),0)}\FPifeq{\resu}{0}{\newline}\else{}\fi}}\iftoggle{printreserveinner}{\newline\noindent\forloop{teams}{1}{\value{teams}<\totalteamsPO}{\forloop{reserve}{0}{\value{reserve}<4}{\blNew{\iftoggle{printreserveteamnumbersinner}{\theteams}{}}{}}\newline}}{}}

\AtBeginDocument{\printblancs}

