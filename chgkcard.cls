\ProvidesClass{chgkcard}[2018/08/10 v0.2 class for creating ChGK tournaments blanks]
\RequirePackage{kvoptions}%to process keyval options
\RequirePackage{iftex}%detect the engine
\DeclareStringOption[2]{teams}
\DeclareStringOption[36]{questions}
\DeclareStringOption[3]{reserve}
\DeclareBoolOption{printreserve}
\DeclareBoolOption[true]{printteamsatall}
\DeclareBoolOption[true]{printquestions}
\DeclareBoolOption{printreserveteamnumbers}
\ProcessKeyvalOptions*
\LoadClass[a4paper, 12pt, landscape]{article}
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
\RequirePackage{xcolor}
\geometry{
	total={297mm,210mm},
	left=0mm,
	% right=0mm,
	% top=0mm,
	bottom=0mm,
}
\topskip0pt

\newcommand{\imago}{\[\textcolor{lightgray}{\hat{(}\grave{\odot}{\scriptstyle\vee}\acute{\odot}\hat{)}}\]} % just an ascii owl; can be replaced with a proper background image

\newcommand{\blNew}[2]{\noindent\fbox{\begin{minipage}[t][66.7mm][t]{97mm}{Команда:~#1}\hfill{Вопрос:~#2\phantom{9}}\vfill\imago\vfill\hspace{0pt}\end{minipage}}}%a card printer with an owl. The team and question numbers are increased by 1

\newcommand{\totalteams}{\chgkcard@teams}% total number of questions
% \newcommand{\totalteamsPR}{3}% total number of questions
\newcommand{\totalquests}{\chgkcard@questions}% total number of questions+1
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

\newcommand{\teamoutput}{\iftoggle{printteamsatallinner}{\theteams}{}}%
\newcommand{\questoutput}{\iftoggle{printquestionsinner}{\thequest}{}}%

\newcommand{\dowereturn}{\stepcounter{stepTZ}\FPeval{\resu}{trunc(\thestepTZ-(3*trunc(\thestepTZ/3,0)),0)}\FPifeq{\resu}{0}{\newline}\else{}\fi}%increases the number of printed cards and add a newline if necessary

\newcommand{\printblancs}{\ifXeTeX\setmainfont{Lucida Console}\else\fi%
\newcounter{teams}%number of teams
\newcounter{quest}%questions
\newcounter{reservecounter}%number of additional blanks; printed without question numbers
\newcounter{stepTZ}%
\setcounter{stepTZ}{0}%
\noindent\forloop{teams}{1}{\numexpr\value{teams}-1<\totalteams}{\noindent\forloop{quest}{1}{\numexpr\value{quest}-1<\totalquests}{\blNew{\teamoutput}{\questoutput}\dowereturn}}\iftoggle{printreserveinner}{\noindent\forloop{teams}{1}{\numexpr\value{teams}-1<\totalteams}{\forloop{reservecounter}{0}{\value{reservecounter}<\chgkcard@reserve}{\blNew{\iftoggle{printreserveteamnumbersinner}{\theteams}{}}{\phantom{99}}\dowereturn}}}{}}

\AtBeginDocument{\printblancs}

