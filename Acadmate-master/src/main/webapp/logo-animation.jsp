<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>AcadMate | Cinematic Intro</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap" rel="stylesheet">
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

<style>
body{
  margin:0;
  height:100vh;
  display:flex;
  flex-direction:column;
  align-items:center;
  justify-content:center;
  background:#000;
  overflow:hidden;
  font-family:'Poppins',sans-serif;
  color:#fff;
  perspective:800px;
}

/* --- Title --- */
.title{
  display:flex;
  font-size:6rem;
  text-transform:uppercase;
  letter-spacing:8px;
  position:relative;
}
.title span{
  display:inline-block;
  color:transparent;
  background:linear-gradient(180deg,#fff7b0,#facc15,#b8860b);
  -webkit-background-clip:text;
  background-clip:text;
  text-shadow:0 0 40px rgba(255,215,0,.7);
  opacity:0;
  transform:translateZ(-400px) rotateY(60deg);
  animation:flyIn 1.1s ease forwards;
}
@keyframes flyIn{
  0%{opacity:0;transform:translateZ(-400px) rotateY(60deg);}
  60%{opacity:1;transform:translateZ(80px) rotateY(-15deg);}
  100%{transform:translateZ(0) rotateY(0);}
}

/* --- Light sweep --- */
.flare{
  position:absolute;
  top:45%;
  left:-50%;
  width:200%;
  height:3px;
  background:linear-gradient(90deg,transparent,rgba(255,255,200,.9),transparent);
  opacity:0;
  animation:flareSweep 2s ease forwards;
  animation-delay:4.2s;
}
@keyframes flareSweep{
  0%{transform:translateX(-100%);opacity:0;}
  40%{opacity:1;}
  100%{transform:translateX(100%);opacity:0;}
}

/* --- Roles --- */
.roles{
  display:flex;
  gap:60px;
  margin-top:60px;
  opacity:0;
  animation:fadeUp 1.5s ease 5.5s forwards;
}
.role{text-align:center;}
.role i{
  font-size:2.5rem;
  color:#facc15;
  text-shadow:0 0 10px #fde047;
}
.role span{display:block;margin-top:10px;color:#e5e5e5;font-size:1rem;}
@keyframes fadeUp{from{opacity:0;transform:translateY(40px);}to{opacity:1;transform:translateY(0);}}

/* --- Quote --- */
.quote{
  position:absolute;
  bottom:60px;
  text-align:center;
  font-size:1.3rem;
  color:#fef9c3;
  opacity:0;
  text-shadow:0 0 10px rgba(255,215,0,.7);
  animation:fadeUp 1.5s ease 6.5s forwards;
}

/* --- Fade out --- */
.fade-out{animation:fadeOut 1.2s ease forwards;}
@keyframes fadeOut{to{opacity:0;transform:scale(1.3);filter:blur(10px);}}
</style>
</head>

<body>
<div class="title" id="title"></div>
<div class="flare"></div>

<div class="roles">
  <div class="role"><i class="fas fa-user-shield"></i><span>Admin</span></div>
  <div class="role"><i class="fas fa-chalkboard-teacher"></i><span>Faculty</span></div>
  <div class="role"><i class="fas fa-calendar-check"></i><span>Organizer</span></div>
  <div class="role"><i class="fas fa-user-graduate"></i><span>Student</span></div>
</div>

<div class="quote">“Empowering Every Mind, Every Campus, Every Moment.”</div>

<script>
/*  Letters appear quickly one after another  */
const title=document.getElementById('title');
const text="ACADMATE";
for(let i=0;i<text.length;i++){
  const span=document.createElement('span');
  span.textContent=text[i];
  span.style.animationDelay=`${i*0.6}s`; // 0.6 s gap between letters
  title.appendChild(span);
}

/* Redirect smoothly after full animation */
const params=new URLSearchParams(window.location.search);
const redirect=params.get("redirect")||"login.jsp";
setTimeout(()=>document.body.classList.add('fade-out'),8500);
setTimeout(()=>window.location.href=redirect,9800);
</script>
</body>
</html>
