
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <forkTest>:
#include "types.h"
#include "user.h"

static void 
forkTest(uint nval){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
 uint uid, gid;
 int pid; 
 printf(1, "setting UID to: %d and Setting GID to: %d before fork()\n", nval, nval);
   6:	ff 75 08             	pushl  0x8(%ebp)
   9:	ff 75 08             	pushl  0x8(%ebp)
   c:	68 5c 0a 00 00       	push   $0xa5c
  11:	6a 01                	push   $0x1
  13:	e8 8d 06 00 00       	call   6a5 <printf>
  18:	83 c4 10             	add    $0x10,%esp
 
 if(setuid(nval) < 0)
  1b:	83 ec 0c             	sub    $0xc,%esp
  1e:	ff 75 08             	pushl  0x8(%ebp)
  21:	e8 70 05 00 00       	call   596 <setuid>
  26:	83 c4 10             	add    $0x10,%esp
  29:	85 c0                	test   %eax,%eax
  2b:	79 15                	jns    42 <forkTest+0x42>
   printf(2, "Invalid uid %d\n", nval);
  2d:	83 ec 04             	sub    $0x4,%esp
  30:	ff 75 08             	pushl  0x8(%ebp)
  33:	68 95 0a 00 00       	push   $0xa95
  38:	6a 02                	push   $0x2
  3a:	e8 66 06 00 00       	call   6a5 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
 
 if(setgid(nval) < 0)
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	ff 75 08             	pushl  0x8(%ebp)
  48:	e8 51 05 00 00       	call   59e <setgid>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	85 c0                	test   %eax,%eax
  52:	79 15                	jns    69 <forkTest+0x69>
   printf(2, "Invalid gid %d\n", nval);
  54:	83 ec 04             	sub    $0x4,%esp
  57:	ff 75 08             	pushl  0x8(%ebp)
  5a:	68 a5 0a 00 00       	push   $0xaa5
  5f:	6a 02                	push   $0x2
  61:	e8 3f 06 00 00       	call   6a5 <printf>
  66:	83 c4 10             	add    $0x10,%esp


 uid = getuid();
  69:	e8 10 05 00 00       	call   57e <getuid>
  6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 printf(2, "Current uid is: %d\n", uid);
  71:	83 ec 04             	sub    $0x4,%esp
  74:	ff 75 f4             	pushl  -0xc(%ebp)
  77:	68 b5 0a 00 00       	push   $0xab5
  7c:	6a 02                	push   $0x2
  7e:	e8 22 06 00 00       	call   6a5 <printf>
  83:	83 c4 10             	add    $0x10,%esp

 pid = fork();
  86:	e8 3b 04 00 00       	call   4c6 <fork>
  8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 if(pid == 0){
  8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  92:	75 3a                	jne    ce <forkTest+0xce>
   uid = getuid();
  94:	e8 e5 04 00 00       	call   57e <getuid>
  99:	89 45 f4             	mov    %eax,-0xc(%ebp)
   gid = getgid();
  9c:	e8 e5 04 00 00       	call   586 <getgid>
  a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
   printf(1, "Child UID is: %d, GID is: %d\n", uid, gid);
  a4:	ff 75 ec             	pushl  -0x14(%ebp)
  a7:	ff 75 f4             	pushl  -0xc(%ebp)
  aa:	68 c9 0a 00 00       	push   $0xac9
  af:	6a 01                	push   $0x1
  b1:	e8 ef 05 00 00       	call   6a5 <printf>
  b6:	83 c4 10             	add    $0x10,%esp
   sleep(2* TPS);
  b9:	83 ec 0c             	sub    $0xc,%esp
  bc:	68 d0 07 00 00       	push   $0x7d0
  c1:	e8 98 04 00 00       	call   55e <sleep>
  c6:	83 c4 10             	add    $0x10,%esp
   exit(); 
  c9:	e8 00 04 00 00       	call   4ce <exit>
 }else
   sleep(2* TPS);
  ce:	83 ec 0c             	sub    $0xc,%esp
  d1:	68 d0 07 00 00       	push   $0x7d0
  d6:	e8 83 04 00 00       	call   55e <sleep>
  db:	83 c4 10             	add    $0x10,%esp
}
  de:	90                   	nop
  df:	c9                   	leave  
  e0:	c3                   	ret    

000000e1 <testuidgid>:

int
testuidgid(void){
  e1:	55                   	push   %ebp
  e2:	89 e5                	mov    %esp,%ebp
  e4:	83 ec 18             	sub    $0x18,%esp
  uint uid, gid, ppid;
  // check for out of range value for negative test  
  forkTest(100);
  e7:	83 ec 0c             	sub    $0xc,%esp
  ea:	6a 64                	push   $0x64
  ec:	e8 0f ff ff ff       	call   0 <forkTest>
  f1:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  f4:	e8 85 04 00 00       	call   57e <getuid>
  f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
  fc:	83 ec 04             	sub    $0x4,%esp
  ff:	ff 75 f4             	pushl  -0xc(%ebp)
 102:	68 e7 0a 00 00       	push   $0xae7
 107:	6a 02                	push   $0x2
 109:	e8 97 05 00 00       	call   6a5 <printf>
 10e:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting UID to 100\n");
 111:	83 ec 08             	sub    $0x8,%esp
 114:	68 fb 0a 00 00       	push   $0xafb
 119:	6a 02                	push   $0x2
 11b:	e8 85 05 00 00       	call   6a5 <printf>
 120:	83 c4 10             	add    $0x10,%esp
  setuid(100);
 123:	83 ec 0c             	sub    $0xc,%esp
 126:	6a 64                	push   $0x64
 128:	e8 69 04 00 00       	call   596 <setuid>
 12d:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
 130:	e8 49 04 00 00       	call   57e <getuid>
 135:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	ff 75 f4             	pushl  -0xc(%ebp)
 13e:	68 e7 0a 00 00       	push   $0xae7
 143:	6a 02                	push   $0x2
 145:	e8 5b 05 00 00       	call   6a5 <printf>
 14a:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
 14d:	e8 34 04 00 00       	call   586 <getgid>
 152:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
 155:	83 ec 04             	sub    $0x4,%esp
 158:	ff 75 f0             	pushl  -0x10(%ebp)
 15b:	68 0f 0b 00 00       	push   $0xb0f
 160:	6a 02                	push   $0x2
 162:	e8 3e 05 00 00       	call   6a5 <printf>
 167:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting GID to 100\n");
 16a:	83 ec 08             	sub    $0x8,%esp
 16d:	68 23 0b 00 00       	push   $0xb23
 172:	6a 02                	push   $0x2
 174:	e8 2c 05 00 00       	call   6a5 <printf>
 179:	83 c4 10             	add    $0x10,%esp
  setgid(100);
 17c:	83 ec 0c             	sub    $0xc,%esp
 17f:	6a 64                	push   $0x64
 181:	e8 18 04 00 00       	call   59e <setgid>
 186:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
 189:	e8 f8 03 00 00       	call   586 <getgid>
 18e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
 191:	83 ec 04             	sub    $0x4,%esp
 194:	ff 75 f0             	pushl  -0x10(%ebp)
 197:	68 0f 0b 00 00       	push   $0xb0f
 19c:	6a 02                	push   $0x2
 19e:	e8 02 05 00 00       	call   6a5 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp

  ppid = getppid();
 1a6:	e8 e3 03 00 00       	call   58e <getppid>
 1ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(2, "My parent process  is: %d\n", ppid);
 1ae:	83 ec 04             	sub    $0x4,%esp
 1b1:	ff 75 ec             	pushl  -0x14(%ebp)
 1b4:	68 37 0b 00 00       	push   $0xb37
 1b9:	6a 02                	push   $0x2
 1bb:	e8 e5 04 00 00       	call   6a5 <printf>
 1c0:	83 c4 10             	add    $0x10,%esp
  printf(2, "Done!\n");
 1c3:	83 ec 08             	sub    $0x8,%esp
 1c6:	68 52 0b 00 00       	push   $0xb52
 1cb:	6a 02                	push   $0x2
 1cd:	e8 d3 04 00 00       	call   6a5 <printf>
 1d2:	83 c4 10             	add    $0x10,%esp
  
  return 0;
 1d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <testSched>:

void
testSched(){
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 18             	sub    $0x18,%esp
  int ret = 1;
 1e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i = 0; i < 10 && ret != 0; ++i) 
 1e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1f0:	eb 0c                	jmp    1fe <testSched+0x22>
  ret = fork();
 1f2:	e8 cf 02 00 00       	call   4c6 <fork>
 1f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

void
testSched(){
  int ret = 1;
  for(int i = 0; i < 10 && ret != 0; ++i) 
 1fa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 1fe:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 202:	7f 06                	jg     20a <testSched+0x2e>
 204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 208:	75 e8                	jne    1f2 <testSched+0x16>
  ret = fork();

  if(ret == 0)
 20a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20e:	75 02                	jne    212 <testSched+0x36>
    for(;;);
 210:	eb fe                	jmp    210 <testSched+0x34>
  exit();
 212:	e8 b7 02 00 00       	call   4ce <exit>

00000217 <main>:
}

int
main(int argc, char *argv[])
{
 217:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 21b:	83 e4 f0             	and    $0xfffffff0,%esp
 21e:	ff 71 fc             	pushl  -0x4(%ecx)
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	51                   	push   %ecx
 225:	83 ec 04             	sub    $0x4,%esp
  //int temp = testuidgid(); 
  //printf(1,"temp: %d\n", temp); 
  testSched();
 228:	e8 af ff ff ff       	call   1dc <testSched>
  exit();
 22d:	e8 9c 02 00 00       	call   4ce <exit>

00000232 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	57                   	push   %edi
 236:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 237:	8b 4d 08             	mov    0x8(%ebp),%ecx
 23a:	8b 55 10             	mov    0x10(%ebp),%edx
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	89 cb                	mov    %ecx,%ebx
 242:	89 df                	mov    %ebx,%edi
 244:	89 d1                	mov    %edx,%ecx
 246:	fc                   	cld    
 247:	f3 aa                	rep stos %al,%es:(%edi)
 249:	89 ca                	mov    %ecx,%edx
 24b:	89 fb                	mov    %edi,%ebx
 24d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 250:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 253:	90                   	nop
 254:	5b                   	pop    %ebx
 255:	5f                   	pop    %edi
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    

00000258 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 258:	55                   	push   %ebp
 259:	89 e5                	mov    %esp,%ebp
 25b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 264:	90                   	nop
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	8d 50 01             	lea    0x1(%eax),%edx
 26b:	89 55 08             	mov    %edx,0x8(%ebp)
 26e:	8b 55 0c             	mov    0xc(%ebp),%edx
 271:	8d 4a 01             	lea    0x1(%edx),%ecx
 274:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 277:	0f b6 12             	movzbl (%edx),%edx
 27a:	88 10                	mov    %dl,(%eax)
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	84 c0                	test   %al,%al
 281:	75 e2                	jne    265 <strcpy+0xd>
    ;
  return os;
 283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 286:	c9                   	leave  
 287:	c3                   	ret    

00000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 28b:	eb 08                	jmp    295 <strcmp+0xd>
    p++, q++;
 28d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 291:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	84 c0                	test   %al,%al
 29d:	74 10                	je     2af <strcmp+0x27>
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 10             	movzbl (%eax),%edx
 2a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a8:	0f b6 00             	movzbl (%eax),%eax
 2ab:	38 c2                	cmp    %al,%dl
 2ad:	74 de                	je     28d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	0f b6 00             	movzbl (%eax),%eax
 2b5:	0f b6 d0             	movzbl %al,%edx
 2b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	0f b6 c0             	movzbl %al,%eax
 2c1:	29 c2                	sub    %eax,%edx
 2c3:	89 d0                	mov    %edx,%eax
}
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    

000002c7 <strlen>:

uint
strlen(char *s)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2d4:	eb 04                	jmp    2da <strlen+0x13>
 2d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2da:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	01 d0                	add    %edx,%eax
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	84 c0                	test   %al,%al
 2e7:	75 ed                	jne    2d6 <strlen+0xf>
    ;
  return n;
 2e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ec:	c9                   	leave  
 2ed:	c3                   	ret    

000002ee <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2f1:	8b 45 10             	mov    0x10(%ebp),%eax
 2f4:	50                   	push   %eax
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	ff 75 08             	pushl  0x8(%ebp)
 2fb:	e8 32 ff ff ff       	call   232 <stosb>
 300:	83 c4 0c             	add    $0xc,%esp
  return dst;
 303:	8b 45 08             	mov    0x8(%ebp),%eax
}
 306:	c9                   	leave  
 307:	c3                   	ret    

00000308 <strchr>:

char*
strchr(const char *s, char c)
{
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	83 ec 04             	sub    $0x4,%esp
 30e:	8b 45 0c             	mov    0xc(%ebp),%eax
 311:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 314:	eb 14                	jmp    32a <strchr+0x22>
    if(*s == c)
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 31f:	75 05                	jne    326 <strchr+0x1e>
      return (char*)s;
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	eb 13                	jmp    339 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 326:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	84 c0                	test   %al,%al
 332:	75 e2                	jne    316 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 334:	b8 00 00 00 00       	mov    $0x0,%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <gets>:

char*
gets(char *buf, int max)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 341:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 348:	eb 42                	jmp    38c <gets+0x51>
    cc = read(0, &c, 1);
 34a:	83 ec 04             	sub    $0x4,%esp
 34d:	6a 01                	push   $0x1
 34f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 352:	50                   	push   %eax
 353:	6a 00                	push   $0x0
 355:	e8 8c 01 00 00       	call   4e6 <read>
 35a:	83 c4 10             	add    $0x10,%esp
 35d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 364:	7e 33                	jle    399 <gets+0x5e>
      break;
    buf[i++] = c;
 366:	8b 45 f4             	mov    -0xc(%ebp),%eax
 369:	8d 50 01             	lea    0x1(%eax),%edx
 36c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 36f:	89 c2                	mov    %eax,%edx
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	01 c2                	add    %eax,%edx
 376:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 37a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 37c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 380:	3c 0a                	cmp    $0xa,%al
 382:	74 16                	je     39a <gets+0x5f>
 384:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 388:	3c 0d                	cmp    $0xd,%al
 38a:	74 0e                	je     39a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38f:	83 c0 01             	add    $0x1,%eax
 392:	3b 45 0c             	cmp    0xc(%ebp),%eax
 395:	7c b3                	jl     34a <gets+0xf>
 397:	eb 01                	jmp    39a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 399:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 39a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	01 d0                	add    %edx,%eax
 3a2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a8:	c9                   	leave  
 3a9:	c3                   	ret    

000003aa <stat>:

int
stat(char *n, struct stat *st)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b0:	83 ec 08             	sub    $0x8,%esp
 3b3:	6a 00                	push   $0x0
 3b5:	ff 75 08             	pushl  0x8(%ebp)
 3b8:	e8 51 01 00 00       	call   50e <open>
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3c7:	79 07                	jns    3d0 <stat+0x26>
    return -1;
 3c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ce:	eb 25                	jmp    3f5 <stat+0x4b>
  r = fstat(fd, st);
 3d0:	83 ec 08             	sub    $0x8,%esp
 3d3:	ff 75 0c             	pushl  0xc(%ebp)
 3d6:	ff 75 f4             	pushl  -0xc(%ebp)
 3d9:	e8 48 01 00 00       	call   526 <fstat>
 3de:	83 c4 10             	add    $0x10,%esp
 3e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3e4:	83 ec 0c             	sub    $0xc,%esp
 3e7:	ff 75 f4             	pushl  -0xc(%ebp)
 3ea:	e8 07 01 00 00       	call   4f6 <close>
 3ef:	83 c4 10             	add    $0x10,%esp
  return r;
 3f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <atoi>:

int
atoi(const char *s)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 404:	eb 04                	jmp    40a <atoi+0x13>
 406:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	0f b6 00             	movzbl (%eax),%eax
 410:	3c 20                	cmp    $0x20,%al
 412:	74 f2                	je     406 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	0f b6 00             	movzbl (%eax),%eax
 41a:	3c 2d                	cmp    $0x2d,%al
 41c:	75 07                	jne    425 <atoi+0x2e>
 41e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 423:	eb 05                	jmp    42a <atoi+0x33>
 425:	b8 01 00 00 00       	mov    $0x1,%eax
 42a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 42d:	8b 45 08             	mov    0x8(%ebp),%eax
 430:	0f b6 00             	movzbl (%eax),%eax
 433:	3c 2b                	cmp    $0x2b,%al
 435:	74 0a                	je     441 <atoi+0x4a>
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	0f b6 00             	movzbl (%eax),%eax
 43d:	3c 2d                	cmp    $0x2d,%al
 43f:	75 2b                	jne    46c <atoi+0x75>
    s++;
 441:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 445:	eb 25                	jmp    46c <atoi+0x75>
    n = n*10 + *s++ - '0';
 447:	8b 55 fc             	mov    -0x4(%ebp),%edx
 44a:	89 d0                	mov    %edx,%eax
 44c:	c1 e0 02             	shl    $0x2,%eax
 44f:	01 d0                	add    %edx,%eax
 451:	01 c0                	add    %eax,%eax
 453:	89 c1                	mov    %eax,%ecx
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	8d 50 01             	lea    0x1(%eax),%edx
 45b:	89 55 08             	mov    %edx,0x8(%ebp)
 45e:	0f b6 00             	movzbl (%eax),%eax
 461:	0f be c0             	movsbl %al,%eax
 464:	01 c8                	add    %ecx,%eax
 466:	83 e8 30             	sub    $0x30,%eax
 469:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	3c 2f                	cmp    $0x2f,%al
 474:	7e 0a                	jle    480 <atoi+0x89>
 476:	8b 45 08             	mov    0x8(%ebp),%eax
 479:	0f b6 00             	movzbl (%eax),%eax
 47c:	3c 39                	cmp    $0x39,%al
 47e:	7e c7                	jle    447 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 480:	8b 45 f8             	mov    -0x8(%ebp),%eax
 483:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 487:	c9                   	leave  
 488:	c3                   	ret    

00000489 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 489:	55                   	push   %ebp
 48a:	89 e5                	mov    %esp,%ebp
 48c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 495:	8b 45 0c             	mov    0xc(%ebp),%eax
 498:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 49b:	eb 17                	jmp    4b4 <memmove+0x2b>
    *dst++ = *src++;
 49d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a0:	8d 50 01             	lea    0x1(%eax),%edx
 4a3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4a9:	8d 4a 01             	lea    0x1(%edx),%ecx
 4ac:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4af:	0f b6 12             	movzbl (%edx),%edx
 4b2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4b4:	8b 45 10             	mov    0x10(%ebp),%eax
 4b7:	8d 50 ff             	lea    -0x1(%eax),%edx
 4ba:	89 55 10             	mov    %edx,0x10(%ebp)
 4bd:	85 c0                	test   %eax,%eax
 4bf:	7f dc                	jg     49d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c4:	c9                   	leave  
 4c5:	c3                   	ret    

000004c6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4c6:	b8 01 00 00 00       	mov    $0x1,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <exit>:
SYSCALL(exit)
 4ce:	b8 02 00 00 00       	mov    $0x2,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <wait>:
SYSCALL(wait)
 4d6:	b8 03 00 00 00       	mov    $0x3,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <pipe>:
SYSCALL(pipe)
 4de:	b8 04 00 00 00       	mov    $0x4,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <read>:
SYSCALL(read)
 4e6:	b8 05 00 00 00       	mov    $0x5,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <write>:
SYSCALL(write)
 4ee:	b8 10 00 00 00       	mov    $0x10,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <close>:
SYSCALL(close)
 4f6:	b8 15 00 00 00       	mov    $0x15,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <kill>:
SYSCALL(kill)
 4fe:	b8 06 00 00 00       	mov    $0x6,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <exec>:
SYSCALL(exec)
 506:	b8 07 00 00 00       	mov    $0x7,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <open>:
SYSCALL(open)
 50e:	b8 0f 00 00 00       	mov    $0xf,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <mknod>:
SYSCALL(mknod)
 516:	b8 11 00 00 00       	mov    $0x11,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <unlink>:
SYSCALL(unlink)
 51e:	b8 12 00 00 00       	mov    $0x12,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <fstat>:
SYSCALL(fstat)
 526:	b8 08 00 00 00       	mov    $0x8,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <link>:
SYSCALL(link)
 52e:	b8 13 00 00 00       	mov    $0x13,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <mkdir>:
SYSCALL(mkdir)
 536:	b8 14 00 00 00       	mov    $0x14,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <chdir>:
SYSCALL(chdir)
 53e:	b8 09 00 00 00       	mov    $0x9,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <dup>:
SYSCALL(dup)
 546:	b8 0a 00 00 00       	mov    $0xa,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <getpid>:
SYSCALL(getpid)
 54e:	b8 0b 00 00 00       	mov    $0xb,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <sbrk>:
SYSCALL(sbrk)
 556:	b8 0c 00 00 00       	mov    $0xc,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <sleep>:
SYSCALL(sleep)
 55e:	b8 0d 00 00 00       	mov    $0xd,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <uptime>:
SYSCALL(uptime)
 566:	b8 0e 00 00 00       	mov    $0xe,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <halt>:
SYSCALL(halt)
 56e:	b8 16 00 00 00       	mov    $0x16,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <date>:
SYSCALL(date)
 576:	b8 17 00 00 00       	mov    $0x17,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <getuid>:
SYSCALL(getuid)
 57e:	b8 18 00 00 00       	mov    $0x18,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <getgid>:
SYSCALL(getgid)
 586:	b8 19 00 00 00       	mov    $0x19,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <getppid>:
SYSCALL(getppid)
 58e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <setuid>:
SYSCALL(setuid)
 596:	b8 1b 00 00 00       	mov    $0x1b,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <setgid>:
SYSCALL(setgid)
 59e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <getprocs>:
SYSCALL(getprocs)
 5a6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <setpriority>:
SYSCALL(setpriority)
 5ae:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <chmod>:
SYSCALL(chmod)
 5b6:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <chown>:
SYSCALL(chown)
 5be:	b8 20 00 00 00       	mov    $0x20,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <chgrp>:
SYSCALL(chgrp)
 5c6:	b8 21 00 00 00       	mov    $0x21,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5ce:	55                   	push   %ebp
 5cf:	89 e5                	mov    %esp,%ebp
 5d1:	83 ec 18             	sub    $0x18,%esp
 5d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5da:	83 ec 04             	sub    $0x4,%esp
 5dd:	6a 01                	push   $0x1
 5df:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5e2:	50                   	push   %eax
 5e3:	ff 75 08             	pushl  0x8(%ebp)
 5e6:	e8 03 ff ff ff       	call   4ee <write>
 5eb:	83 c4 10             	add    $0x10,%esp
}
 5ee:	90                   	nop
 5ef:	c9                   	leave  
 5f0:	c3                   	ret    

000005f1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f1:	55                   	push   %ebp
 5f2:	89 e5                	mov    %esp,%ebp
 5f4:	53                   	push   %ebx
 5f5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 603:	74 17                	je     61c <printint+0x2b>
 605:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 609:	79 11                	jns    61c <printint+0x2b>
    neg = 1;
 60b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 612:	8b 45 0c             	mov    0xc(%ebp),%eax
 615:	f7 d8                	neg    %eax
 617:	89 45 ec             	mov    %eax,-0x14(%ebp)
 61a:	eb 06                	jmp    622 <printint+0x31>
  } else {
    x = xx;
 61c:	8b 45 0c             	mov    0xc(%ebp),%eax
 61f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 629:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 62c:	8d 41 01             	lea    0x1(%ecx),%eax
 62f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 632:	8b 5d 10             	mov    0x10(%ebp),%ebx
 635:	8b 45 ec             	mov    -0x14(%ebp),%eax
 638:	ba 00 00 00 00       	mov    $0x0,%edx
 63d:	f7 f3                	div    %ebx
 63f:	89 d0                	mov    %edx,%eax
 641:	0f b6 80 04 0e 00 00 	movzbl 0xe04(%eax),%eax
 648:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 64c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 64f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 652:	ba 00 00 00 00       	mov    $0x0,%edx
 657:	f7 f3                	div    %ebx
 659:	89 45 ec             	mov    %eax,-0x14(%ebp)
 65c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 660:	75 c7                	jne    629 <printint+0x38>
  if(neg)
 662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 666:	74 2d                	je     695 <printint+0xa4>
    buf[i++] = '-';
 668:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66b:	8d 50 01             	lea    0x1(%eax),%edx
 66e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 671:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 676:	eb 1d                	jmp    695 <printint+0xa4>
    putc(fd, buf[i]);
 678:	8d 55 dc             	lea    -0x24(%ebp),%edx
 67b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67e:	01 d0                	add    %edx,%eax
 680:	0f b6 00             	movzbl (%eax),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	83 ec 08             	sub    $0x8,%esp
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 3c ff ff ff       	call   5ce <putc>
 692:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 695:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 699:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69d:	79 d9                	jns    678 <printint+0x87>
    putc(fd, buf[i]);
}
 69f:	90                   	nop
 6a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6a3:	c9                   	leave  
 6a4:	c3                   	ret    

000006a5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6a5:	55                   	push   %ebp
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6b2:	8d 45 0c             	lea    0xc(%ebp),%eax
 6b5:	83 c0 04             	add    $0x4,%eax
 6b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6c2:	e9 59 01 00 00       	jmp    820 <printf+0x17b>
    c = fmt[i] & 0xff;
 6c7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cd:	01 d0                	add    %edx,%eax
 6cf:	0f b6 00             	movzbl (%eax),%eax
 6d2:	0f be c0             	movsbl %al,%eax
 6d5:	25 ff 00 00 00       	and    $0xff,%eax
 6da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e1:	75 2c                	jne    70f <printf+0x6a>
      if(c == '%'){
 6e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e7:	75 0c                	jne    6f5 <printf+0x50>
        state = '%';
 6e9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6f0:	e9 27 01 00 00       	jmp    81c <printf+0x177>
      } else {
        putc(fd, c);
 6f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	83 ec 08             	sub    $0x8,%esp
 6fe:	50                   	push   %eax
 6ff:	ff 75 08             	pushl  0x8(%ebp)
 702:	e8 c7 fe ff ff       	call   5ce <putc>
 707:	83 c4 10             	add    $0x10,%esp
 70a:	e9 0d 01 00 00       	jmp    81c <printf+0x177>
      }
    } else if(state == '%'){
 70f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 713:	0f 85 03 01 00 00    	jne    81c <printf+0x177>
      if(c == 'd'){
 719:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 71d:	75 1e                	jne    73d <printf+0x98>
        printint(fd, *ap, 10, 1);
 71f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	6a 01                	push   $0x1
 726:	6a 0a                	push   $0xa
 728:	50                   	push   %eax
 729:	ff 75 08             	pushl  0x8(%ebp)
 72c:	e8 c0 fe ff ff       	call   5f1 <printint>
 731:	83 c4 10             	add    $0x10,%esp
        ap++;
 734:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 738:	e9 d8 00 00 00       	jmp    815 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 73d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 741:	74 06                	je     749 <printf+0xa4>
 743:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 747:	75 1e                	jne    767 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 749:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	6a 00                	push   $0x0
 750:	6a 10                	push   $0x10
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 96 fe ff ff       	call   5f1 <printint>
 75b:	83 c4 10             	add    $0x10,%esp
        ap++;
 75e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 762:	e9 ae 00 00 00       	jmp    815 <printf+0x170>
      } else if(c == 's'){
 767:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 76b:	75 43                	jne    7b0 <printf+0x10b>
        s = (char*)*ap;
 76d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 775:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77d:	75 25                	jne    7a4 <printf+0xff>
          s = "(null)";
 77f:	c7 45 f4 59 0b 00 00 	movl   $0xb59,-0xc(%ebp)
        while(*s != 0){
 786:	eb 1c                	jmp    7a4 <printf+0xff>
          putc(fd, *s);
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	0f b6 00             	movzbl (%eax),%eax
 78e:	0f be c0             	movsbl %al,%eax
 791:	83 ec 08             	sub    $0x8,%esp
 794:	50                   	push   %eax
 795:	ff 75 08             	pushl  0x8(%ebp)
 798:	e8 31 fe ff ff       	call   5ce <putc>
 79d:	83 c4 10             	add    $0x10,%esp
          s++;
 7a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	0f b6 00             	movzbl (%eax),%eax
 7aa:	84 c0                	test   %al,%al
 7ac:	75 da                	jne    788 <printf+0xe3>
 7ae:	eb 65                	jmp    815 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7b0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7b4:	75 1d                	jne    7d3 <printf+0x12e>
        putc(fd, *ap);
 7b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	0f be c0             	movsbl %al,%eax
 7be:	83 ec 08             	sub    $0x8,%esp
 7c1:	50                   	push   %eax
 7c2:	ff 75 08             	pushl  0x8(%ebp)
 7c5:	e8 04 fe ff ff       	call   5ce <putc>
 7ca:	83 c4 10             	add    $0x10,%esp
        ap++;
 7cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d1:	eb 42                	jmp    815 <printf+0x170>
      } else if(c == '%'){
 7d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d7:	75 17                	jne    7f0 <printf+0x14b>
        putc(fd, c);
 7d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7dc:	0f be c0             	movsbl %al,%eax
 7df:	83 ec 08             	sub    $0x8,%esp
 7e2:	50                   	push   %eax
 7e3:	ff 75 08             	pushl  0x8(%ebp)
 7e6:	e8 e3 fd ff ff       	call   5ce <putc>
 7eb:	83 c4 10             	add    $0x10,%esp
 7ee:	eb 25                	jmp    815 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f0:	83 ec 08             	sub    $0x8,%esp
 7f3:	6a 25                	push   $0x25
 7f5:	ff 75 08             	pushl  0x8(%ebp)
 7f8:	e8 d1 fd ff ff       	call   5ce <putc>
 7fd:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 803:	0f be c0             	movsbl %al,%eax
 806:	83 ec 08             	sub    $0x8,%esp
 809:	50                   	push   %eax
 80a:	ff 75 08             	pushl  0x8(%ebp)
 80d:	e8 bc fd ff ff       	call   5ce <putc>
 812:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 815:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 81c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 820:	8b 55 0c             	mov    0xc(%ebp),%edx
 823:	8b 45 f0             	mov    -0x10(%ebp),%eax
 826:	01 d0                	add    %edx,%eax
 828:	0f b6 00             	movzbl (%eax),%eax
 82b:	84 c0                	test   %al,%al
 82d:	0f 85 94 fe ff ff    	jne    6c7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 833:	90                   	nop
 834:	c9                   	leave  
 835:	c3                   	ret    

00000836 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 836:	55                   	push   %ebp
 837:	89 e5                	mov    %esp,%ebp
 839:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83c:	8b 45 08             	mov    0x8(%ebp),%eax
 83f:	83 e8 08             	sub    $0x8,%eax
 842:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 845:	a1 20 0e 00 00       	mov    0xe20,%eax
 84a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84d:	eb 24                	jmp    873 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 852:	8b 00                	mov    (%eax),%eax
 854:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 857:	77 12                	ja     86b <free+0x35>
 859:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 85f:	77 24                	ja     885 <free+0x4f>
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 869:	77 1a                	ja     885 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	8b 00                	mov    (%eax),%eax
 870:	89 45 fc             	mov    %eax,-0x4(%ebp)
 873:	8b 45 f8             	mov    -0x8(%ebp),%eax
 876:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 879:	76 d4                	jbe    84f <free+0x19>
 87b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87e:	8b 00                	mov    (%eax),%eax
 880:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 883:	76 ca                	jbe    84f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 885:	8b 45 f8             	mov    -0x8(%ebp),%eax
 888:	8b 40 04             	mov    0x4(%eax),%eax
 88b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 892:	8b 45 f8             	mov    -0x8(%ebp),%eax
 895:	01 c2                	add    %eax,%edx
 897:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	39 c2                	cmp    %eax,%edx
 89e:	75 24                	jne    8c4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a3:	8b 50 04             	mov    0x4(%eax),%edx
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	8b 40 04             	mov    0x4(%eax),%eax
 8ae:	01 c2                	add    %eax,%edx
 8b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b9:	8b 00                	mov    (%eax),%eax
 8bb:	8b 10                	mov    (%eax),%edx
 8bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c0:	89 10                	mov    %edx,(%eax)
 8c2:	eb 0a                	jmp    8ce <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	8b 10                	mov    (%eax),%edx
 8c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8b 40 04             	mov    0x4(%eax),%eax
 8d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8de:	01 d0                	add    %edx,%eax
 8e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e3:	75 20                	jne    905 <free+0xcf>
    p->s.size += bp->s.size;
 8e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e8:	8b 50 04             	mov    0x4(%eax),%edx
 8eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	01 c2                	add    %eax,%edx
 8f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fc:	8b 10                	mov    (%eax),%edx
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	89 10                	mov    %edx,(%eax)
 903:	eb 08                	jmp    90d <free+0xd7>
  } else
    p->s.ptr = bp;
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 55 f8             	mov    -0x8(%ebp),%edx
 90b:	89 10                	mov    %edx,(%eax)
  freep = p;
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	a3 20 0e 00 00       	mov    %eax,0xe20
}
 915:	90                   	nop
 916:	c9                   	leave  
 917:	c3                   	ret    

00000918 <morecore>:

static Header*
morecore(uint nu)
{
 918:	55                   	push   %ebp
 919:	89 e5                	mov    %esp,%ebp
 91b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 91e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 925:	77 07                	ja     92e <morecore+0x16>
    nu = 4096;
 927:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 92e:	8b 45 08             	mov    0x8(%ebp),%eax
 931:	c1 e0 03             	shl    $0x3,%eax
 934:	83 ec 0c             	sub    $0xc,%esp
 937:	50                   	push   %eax
 938:	e8 19 fc ff ff       	call   556 <sbrk>
 93d:	83 c4 10             	add    $0x10,%esp
 940:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 943:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 947:	75 07                	jne    950 <morecore+0x38>
    return 0;
 949:	b8 00 00 00 00       	mov    $0x0,%eax
 94e:	eb 26                	jmp    976 <morecore+0x5e>
  hp = (Header*)p;
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 956:	8b 45 f0             	mov    -0x10(%ebp),%eax
 959:	8b 55 08             	mov    0x8(%ebp),%edx
 95c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 95f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 962:	83 c0 08             	add    $0x8,%eax
 965:	83 ec 0c             	sub    $0xc,%esp
 968:	50                   	push   %eax
 969:	e8 c8 fe ff ff       	call   836 <free>
 96e:	83 c4 10             	add    $0x10,%esp
  return freep;
 971:	a1 20 0e 00 00       	mov    0xe20,%eax
}
 976:	c9                   	leave  
 977:	c3                   	ret    

00000978 <malloc>:

void*
malloc(uint nbytes)
{
 978:	55                   	push   %ebp
 979:	89 e5                	mov    %esp,%ebp
 97b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97e:	8b 45 08             	mov    0x8(%ebp),%eax
 981:	83 c0 07             	add    $0x7,%eax
 984:	c1 e8 03             	shr    $0x3,%eax
 987:	83 c0 01             	add    $0x1,%eax
 98a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 98d:	a1 20 0e 00 00       	mov    0xe20,%eax
 992:	89 45 f0             	mov    %eax,-0x10(%ebp)
 995:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 999:	75 23                	jne    9be <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 99b:	c7 45 f0 18 0e 00 00 	movl   $0xe18,-0x10(%ebp)
 9a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a5:	a3 20 0e 00 00       	mov    %eax,0xe20
 9aa:	a1 20 0e 00 00       	mov    0xe20,%eax
 9af:	a3 18 0e 00 00       	mov    %eax,0xe18
    base.s.size = 0;
 9b4:	c7 05 1c 0e 00 00 00 	movl   $0x0,0xe1c
 9bb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c1:	8b 00                	mov    (%eax),%eax
 9c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	8b 40 04             	mov    0x4(%eax),%eax
 9cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9cf:	72 4d                	jb     a1e <malloc+0xa6>
      if(p->s.size == nunits)
 9d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d4:	8b 40 04             	mov    0x4(%eax),%eax
 9d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9da:	75 0c                	jne    9e8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9df:	8b 10                	mov    (%eax),%edx
 9e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e4:	89 10                	mov    %edx,(%eax)
 9e6:	eb 26                	jmp    a0e <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	8b 40 04             	mov    0x4(%eax),%eax
 9ee:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9f1:	89 c2                	mov    %eax,%edx
 9f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fc:	8b 40 04             	mov    0x4(%eax),%eax
 9ff:	c1 e0 03             	shl    $0x3,%eax
 a02:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a0b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a11:	a3 20 0e 00 00       	mov    %eax,0xe20
      return (void*)(p + 1);
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	83 c0 08             	add    $0x8,%eax
 a1c:	eb 3b                	jmp    a59 <malloc+0xe1>
    }
    if(p == freep)
 a1e:	a1 20 0e 00 00       	mov    0xe20,%eax
 a23:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a26:	75 1e                	jne    a46 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a28:	83 ec 0c             	sub    $0xc,%esp
 a2b:	ff 75 ec             	pushl  -0x14(%ebp)
 a2e:	e8 e5 fe ff ff       	call   918 <morecore>
 a33:	83 c4 10             	add    $0x10,%esp
 a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3d:	75 07                	jne    a46 <malloc+0xce>
        return 0;
 a3f:	b8 00 00 00 00       	mov    $0x0,%eax
 a44:	eb 13                	jmp    a59 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	8b 00                	mov    (%eax),%eax
 a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a54:	e9 6d ff ff ff       	jmp    9c6 <malloc+0x4e>
}
 a59:	c9                   	leave  
 a5a:	c3                   	ret    
