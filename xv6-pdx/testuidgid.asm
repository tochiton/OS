
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <testuidgid>:
#include "types.h"
#include "user.h"

int
testuidgid(void){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  uint uid, gid, ppid;
  
  uid = getuid();
   6:	e8 62 04 00 00       	call   46d <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 2a 09 00 00       	push   $0x92a
  19:	6a 02                	push   $0x2
  1b:	e8 54 05 00 00       	call   574 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting UID to 100\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 3e 09 00 00       	push   $0x93e
  2b:	6a 02                	push   $0x2
  2d:	e8 42 05 00 00       	call   574 <printf>
  32:	83 c4 10             	add    $0x10,%esp
  setuid(100);
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	6a 64                	push   $0x64
  3a:	e8 46 04 00 00       	call   485 <setuid>
  3f:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  42:	e8 26 04 00 00       	call   46d <getuid>
  47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 f4             	pushl  -0xc(%ebp)
  50:	68 2a 09 00 00       	push   $0x92a
  55:	6a 02                	push   $0x2
  57:	e8 18 05 00 00       	call   574 <printf>
  5c:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
  5f:	e8 11 04 00 00       	call   475 <getgid>
  64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	ff 75 f0             	pushl  -0x10(%ebp)
  6d:	68 52 09 00 00       	push   $0x952
  72:	6a 02                	push   $0x2
  74:	e8 fb 04 00 00       	call   574 <printf>
  79:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting GID to 100\n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 66 09 00 00       	push   $0x966
  84:	6a 02                	push   $0x2
  86:	e8 e9 04 00 00       	call   574 <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  setgid(100);
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	6a 64                	push   $0x64
  93:	e8 f5 03 00 00       	call   48d <setgid>
  98:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
  9b:	e8 d5 03 00 00       	call   475 <getgid>
  a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
  a3:	83 ec 04             	sub    $0x4,%esp
  a6:	ff 75 f0             	pushl  -0x10(%ebp)
  a9:	68 52 09 00 00       	push   $0x952
  ae:	6a 02                	push   $0x2
  b0:	e8 bf 04 00 00       	call   574 <printf>
  b5:	83 c4 10             	add    $0x10,%esp

  ppid = getppid();
  b8:	e8 c0 03 00 00       	call   47d <getppid>
  bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(2, "My parent process  is: %d\n", ppid);
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	ff 75 ec             	pushl  -0x14(%ebp)
  c6:	68 7a 09 00 00       	push   $0x97a
  cb:	6a 02                	push   $0x2
  cd:	e8 a2 04 00 00       	call   574 <printf>
  d2:	83 c4 10             	add    $0x10,%esp
  printf(2, "Done!\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 95 09 00 00       	push   $0x995
  dd:	6a 02                	push   $0x2
  df:	e8 90 04 00 00       	call   574 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
  
  return 0;
  e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	51                   	push   %ecx
  fc:	83 ec 14             	sub    $0x14,%esp
  int temp = testuidgid(); 
  ff:	e8 fc fe ff ff       	call   0 <testuidgid>
 104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1,"temp: %d\n", temp); 
 107:	83 ec 04             	sub    $0x4,%esp
 10a:	ff 75 f4             	pushl  -0xc(%ebp)
 10d:	68 9c 09 00 00       	push   $0x99c
 112:	6a 01                	push   $0x1
 114:	e8 5b 04 00 00       	call   574 <printf>
 119:	83 c4 10             	add    $0x10,%esp
  exit();
 11c:	e8 9c 02 00 00       	call   3bd <exit>

00000121 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	57                   	push   %edi
 125:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 126:	8b 4d 08             	mov    0x8(%ebp),%ecx
 129:	8b 55 10             	mov    0x10(%ebp),%edx
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	89 cb                	mov    %ecx,%ebx
 131:	89 df                	mov    %ebx,%edi
 133:	89 d1                	mov    %edx,%ecx
 135:	fc                   	cld    
 136:	f3 aa                	rep stos %al,%es:(%edi)
 138:	89 ca                	mov    %ecx,%edx
 13a:	89 fb                	mov    %edi,%ebx
 13c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 142:	90                   	nop
 143:	5b                   	pop    %ebx
 144:	5f                   	pop    %edi
 145:	5d                   	pop    %ebp
 146:	c3                   	ret    

00000147 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 153:	90                   	nop
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8d 50 01             	lea    0x1(%eax),%edx
 15a:	89 55 08             	mov    %edx,0x8(%ebp)
 15d:	8b 55 0c             	mov    0xc(%ebp),%edx
 160:	8d 4a 01             	lea    0x1(%edx),%ecx
 163:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 166:	0f b6 12             	movzbl (%edx),%edx
 169:	88 10                	mov    %dl,(%eax)
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strcpy+0xd>
    ;
  return os;
 172:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 175:	c9                   	leave  
 176:	c3                   	ret    

00000177 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 177:	55                   	push   %ebp
 178:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17a:	eb 08                	jmp    184 <strcmp+0xd>
    p++, q++;
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	84 c0                	test   %al,%al
 18c:	74 10                	je     19e <strcmp+0x27>
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 10             	movzbl (%eax),%edx
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	38 c2                	cmp    %al,%dl
 19c:	74 de                	je     17c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	0f b6 d0             	movzbl %al,%edx
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	0f b6 c0             	movzbl %al,%eax
 1b0:	29 c2                	sub    %eax,%edx
 1b2:	89 d0                	mov    %edx,%eax
}
 1b4:	5d                   	pop    %ebp
 1b5:	c3                   	ret    

000001b6 <strlen>:

uint
strlen(char *s)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c3:	eb 04                	jmp    1c9 <strlen+0x13>
 1c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	01 d0                	add    %edx,%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	84 c0                	test   %al,%al
 1d6:	75 ed                	jne    1c5 <strlen+0xf>
    ;
  return n;
 1d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e0:	8b 45 10             	mov    0x10(%ebp),%eax
 1e3:	50                   	push   %eax
 1e4:	ff 75 0c             	pushl  0xc(%ebp)
 1e7:	ff 75 08             	pushl  0x8(%ebp)
 1ea:	e8 32 ff ff ff       	call   121 <stosb>
 1ef:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <strchr>:

char*
strchr(const char *s, char c)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 04             	sub    $0x4,%esp
 1fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 200:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 203:	eb 14                	jmp    219 <strchr+0x22>
    if(*s == c)
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20e:	75 05                	jne    215 <strchr+0x1e>
      return (char*)s;
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	eb 13                	jmp    228 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	75 e2                	jne    205 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 223:	b8 00 00 00 00       	mov    $0x0,%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <gets>:

char*
gets(char *buf, int max)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 237:	eb 42                	jmp    27b <gets+0x51>
    cc = read(0, &c, 1);
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	6a 01                	push   $0x1
 23e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 241:	50                   	push   %eax
 242:	6a 00                	push   $0x0
 244:	e8 8c 01 00 00       	call   3d5 <read>
 249:	83 c4 10             	add    $0x10,%esp
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 253:	7e 33                	jle    288 <gets+0x5e>
      break;
    buf[i++] = c;
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	8d 50 01             	lea    0x1(%eax),%edx
 25b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25e:	89 c2                	mov    %eax,%edx
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	01 c2                	add    %eax,%edx
 265:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 269:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26f:	3c 0a                	cmp    $0xa,%al
 271:	74 16                	je     289 <gets+0x5f>
 273:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 277:	3c 0d                	cmp    $0xd,%al
 279:	74 0e                	je     289 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27e:	83 c0 01             	add    $0x1,%eax
 281:	3b 45 0c             	cmp    0xc(%ebp),%eax
 284:	7c b3                	jl     239 <gets+0xf>
 286:	eb 01                	jmp    289 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 288:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 289:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	01 d0                	add    %edx,%eax
 291:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 294:	8b 45 08             	mov    0x8(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <stat>:

int
stat(char *n, struct stat *st)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	6a 00                	push   $0x0
 2a4:	ff 75 08             	pushl  0x8(%ebp)
 2a7:	e8 51 01 00 00       	call   3fd <open>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b6:	79 07                	jns    2bf <stat+0x26>
    return -1;
 2b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bd:	eb 25                	jmp    2e4 <stat+0x4b>
  r = fstat(fd, st);
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	ff 75 0c             	pushl  0xc(%ebp)
 2c5:	ff 75 f4             	pushl  -0xc(%ebp)
 2c8:	e8 48 01 00 00       	call   415 <fstat>
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d3:	83 ec 0c             	sub    $0xc,%esp
 2d6:	ff 75 f4             	pushl  -0xc(%ebp)
 2d9:	e8 07 01 00 00       	call   3e5 <close>
 2de:	83 c4 10             	add    $0x10,%esp
  return r;
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2f3:	eb 04                	jmp    2f9 <atoi+0x13>
 2f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	0f b6 00             	movzbl (%eax),%eax
 2ff:	3c 20                	cmp    $0x20,%al
 301:	74 f2                	je     2f5 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	3c 2d                	cmp    $0x2d,%al
 30b:	75 07                	jne    314 <atoi+0x2e>
 30d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 312:	eb 05                	jmp    319 <atoi+0x33>
 314:	b8 01 00 00 00       	mov    $0x1,%eax
 319:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	3c 2b                	cmp    $0x2b,%al
 324:	74 0a                	je     330 <atoi+0x4a>
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	3c 2d                	cmp    $0x2d,%al
 32e:	75 2b                	jne    35b <atoi+0x75>
    s++;
 330:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 334:	eb 25                	jmp    35b <atoi+0x75>
    n = n*10 + *s++ - '0';
 336:	8b 55 fc             	mov    -0x4(%ebp),%edx
 339:	89 d0                	mov    %edx,%eax
 33b:	c1 e0 02             	shl    $0x2,%eax
 33e:	01 d0                	add    %edx,%eax
 340:	01 c0                	add    %eax,%eax
 342:	89 c1                	mov    %eax,%ecx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8d 50 01             	lea    0x1(%eax),%edx
 34a:	89 55 08             	mov    %edx,0x8(%ebp)
 34d:	0f b6 00             	movzbl (%eax),%eax
 350:	0f be c0             	movsbl %al,%eax
 353:	01 c8                	add    %ecx,%eax
 355:	83 e8 30             	sub    $0x30,%eax
 358:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	3c 2f                	cmp    $0x2f,%al
 363:	7e 0a                	jle    36f <atoi+0x89>
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	3c 39                	cmp    $0x39,%al
 36d:	7e c7                	jle    336 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 36f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 372:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 38a:	eb 17                	jmp    3a3 <memmove+0x2b>
    *dst++ = *src++;
 38c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38f:	8d 50 01             	lea    0x1(%eax),%edx
 392:	89 55 fc             	mov    %edx,-0x4(%ebp)
 395:	8b 55 f8             	mov    -0x8(%ebp),%edx
 398:	8d 4a 01             	lea    0x1(%edx),%ecx
 39b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 39e:	0f b6 12             	movzbl (%edx),%edx
 3a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a3:	8b 45 10             	mov    0x10(%ebp),%eax
 3a6:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a9:	89 55 10             	mov    %edx,0x10(%ebp)
 3ac:	85 c0                	test   %eax,%eax
 3ae:	7f dc                	jg     38c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b5:	b8 01 00 00 00       	mov    $0x1,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <exit>:
SYSCALL(exit)
 3bd:	b8 02 00 00 00       	mov    $0x2,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <wait>:
SYSCALL(wait)
 3c5:	b8 03 00 00 00       	mov    $0x3,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <pipe>:
SYSCALL(pipe)
 3cd:	b8 04 00 00 00       	mov    $0x4,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <read>:
SYSCALL(read)
 3d5:	b8 05 00 00 00       	mov    $0x5,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <write>:
SYSCALL(write)
 3dd:	b8 10 00 00 00       	mov    $0x10,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <close>:
SYSCALL(close)
 3e5:	b8 15 00 00 00       	mov    $0x15,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <kill>:
SYSCALL(kill)
 3ed:	b8 06 00 00 00       	mov    $0x6,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <exec>:
SYSCALL(exec)
 3f5:	b8 07 00 00 00       	mov    $0x7,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <open>:
SYSCALL(open)
 3fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <mknod>:
SYSCALL(mknod)
 405:	b8 11 00 00 00       	mov    $0x11,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <unlink>:
SYSCALL(unlink)
 40d:	b8 12 00 00 00       	mov    $0x12,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <fstat>:
SYSCALL(fstat)
 415:	b8 08 00 00 00       	mov    $0x8,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <link>:
SYSCALL(link)
 41d:	b8 13 00 00 00       	mov    $0x13,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <mkdir>:
SYSCALL(mkdir)
 425:	b8 14 00 00 00       	mov    $0x14,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <chdir>:
SYSCALL(chdir)
 42d:	b8 09 00 00 00       	mov    $0x9,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <dup>:
SYSCALL(dup)
 435:	b8 0a 00 00 00       	mov    $0xa,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <getpid>:
SYSCALL(getpid)
 43d:	b8 0b 00 00 00       	mov    $0xb,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <sbrk>:
SYSCALL(sbrk)
 445:	b8 0c 00 00 00       	mov    $0xc,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <sleep>:
SYSCALL(sleep)
 44d:	b8 0d 00 00 00       	mov    $0xd,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <uptime>:
SYSCALL(uptime)
 455:	b8 0e 00 00 00       	mov    $0xe,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <halt>:
SYSCALL(halt)
 45d:	b8 16 00 00 00       	mov    $0x16,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <date>:
SYSCALL(date)
 465:	b8 17 00 00 00       	mov    $0x17,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <getuid>:
SYSCALL(getuid)
 46d:	b8 18 00 00 00       	mov    $0x18,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <getgid>:
SYSCALL(getgid)
 475:	b8 19 00 00 00       	mov    $0x19,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <getppid>:
SYSCALL(getppid)
 47d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <setuid>:
SYSCALL(setuid)
 485:	b8 1b 00 00 00       	mov    $0x1b,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <setgid>:
SYSCALL(setgid)
 48d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <getprocs>:
SYSCALL(getprocs)
 495:	b8 1d 00 00 00       	mov    $0x1d,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 49d:	55                   	push   %ebp
 49e:	89 e5                	mov    %esp,%ebp
 4a0:	83 ec 18             	sub    $0x18,%esp
 4a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4a9:	83 ec 04             	sub    $0x4,%esp
 4ac:	6a 01                	push   $0x1
 4ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b1:	50                   	push   %eax
 4b2:	ff 75 08             	pushl  0x8(%ebp)
 4b5:	e8 23 ff ff ff       	call   3dd <write>
 4ba:	83 c4 10             	add    $0x10,%esp
}
 4bd:	90                   	nop
 4be:	c9                   	leave  
 4bf:	c3                   	ret    

000004c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	53                   	push   %ebx
 4c4:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ce:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d2:	74 17                	je     4eb <printint+0x2b>
 4d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4d8:	79 11                	jns    4eb <printint+0x2b>
    neg = 1;
 4da:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e4:	f7 d8                	neg    %eax
 4e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e9:	eb 06                	jmp    4f1 <printint+0x31>
  } else {
    x = xx;
 4eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4fb:	8d 41 01             	lea    0x1(%ecx),%eax
 4fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
 501:	8b 5d 10             	mov    0x10(%ebp),%ebx
 504:	8b 45 ec             	mov    -0x14(%ebp),%eax
 507:	ba 00 00 00 00       	mov    $0x0,%edx
 50c:	f7 f3                	div    %ebx
 50e:	89 d0                	mov    %edx,%eax
 510:	0f b6 80 18 0c 00 00 	movzbl 0xc18(%eax),%eax
 517:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 51b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 51e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 521:	ba 00 00 00 00       	mov    $0x0,%edx
 526:	f7 f3                	div    %ebx
 528:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52f:	75 c7                	jne    4f8 <printint+0x38>
  if(neg)
 531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 535:	74 2d                	je     564 <printint+0xa4>
    buf[i++] = '-';
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	8d 50 01             	lea    0x1(%eax),%edx
 53d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 540:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 545:	eb 1d                	jmp    564 <printint+0xa4>
    putc(fd, buf[i]);
 547:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54d:	01 d0                	add    %edx,%eax
 54f:	0f b6 00             	movzbl (%eax),%eax
 552:	0f be c0             	movsbl %al,%eax
 555:	83 ec 08             	sub    $0x8,%esp
 558:	50                   	push   %eax
 559:	ff 75 08             	pushl  0x8(%ebp)
 55c:	e8 3c ff ff ff       	call   49d <putc>
 561:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 564:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56c:	79 d9                	jns    547 <printint+0x87>
    putc(fd, buf[i]);
}
 56e:	90                   	nop
 56f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 572:	c9                   	leave  
 573:	c3                   	ret    

00000574 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 57a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 581:	8d 45 0c             	lea    0xc(%ebp),%eax
 584:	83 c0 04             	add    $0x4,%eax
 587:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 58a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 591:	e9 59 01 00 00       	jmp    6ef <printf+0x17b>
    c = fmt[i] & 0xff;
 596:	8b 55 0c             	mov    0xc(%ebp),%edx
 599:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59c:	01 d0                	add    %edx,%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	25 ff 00 00 00       	and    $0xff,%eax
 5a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b0:	75 2c                	jne    5de <printf+0x6a>
      if(c == '%'){
 5b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b6:	75 0c                	jne    5c4 <printf+0x50>
        state = '%';
 5b8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5bf:	e9 27 01 00 00       	jmp    6eb <printf+0x177>
      } else {
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	83 ec 08             	sub    $0x8,%esp
 5cd:	50                   	push   %eax
 5ce:	ff 75 08             	pushl  0x8(%ebp)
 5d1:	e8 c7 fe ff ff       	call   49d <putc>
 5d6:	83 c4 10             	add    $0x10,%esp
 5d9:	e9 0d 01 00 00       	jmp    6eb <printf+0x177>
      }
    } else if(state == '%'){
 5de:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e2:	0f 85 03 01 00 00    	jne    6eb <printf+0x177>
      if(c == 'd'){
 5e8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ec:	75 1e                	jne    60c <printf+0x98>
        printint(fd, *ap, 10, 1);
 5ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f1:	8b 00                	mov    (%eax),%eax
 5f3:	6a 01                	push   $0x1
 5f5:	6a 0a                	push   $0xa
 5f7:	50                   	push   %eax
 5f8:	ff 75 08             	pushl  0x8(%ebp)
 5fb:	e8 c0 fe ff ff       	call   4c0 <printint>
 600:	83 c4 10             	add    $0x10,%esp
        ap++;
 603:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 607:	e9 d8 00 00 00       	jmp    6e4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 60c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 610:	74 06                	je     618 <printf+0xa4>
 612:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 616:	75 1e                	jne    636 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 618:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	6a 00                	push   $0x0
 61f:	6a 10                	push   $0x10
 621:	50                   	push   %eax
 622:	ff 75 08             	pushl  0x8(%ebp)
 625:	e8 96 fe ff ff       	call   4c0 <printint>
 62a:	83 c4 10             	add    $0x10,%esp
        ap++;
 62d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 631:	e9 ae 00 00 00       	jmp    6e4 <printf+0x170>
      } else if(c == 's'){
 636:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63a:	75 43                	jne    67f <printf+0x10b>
        s = (char*)*ap;
 63c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 644:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64c:	75 25                	jne    673 <printf+0xff>
          s = "(null)";
 64e:	c7 45 f4 a6 09 00 00 	movl   $0x9a6,-0xc(%ebp)
        while(*s != 0){
 655:	eb 1c                	jmp    673 <printf+0xff>
          putc(fd, *s);
 657:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65a:	0f b6 00             	movzbl (%eax),%eax
 65d:	0f be c0             	movsbl %al,%eax
 660:	83 ec 08             	sub    $0x8,%esp
 663:	50                   	push   %eax
 664:	ff 75 08             	pushl  0x8(%ebp)
 667:	e8 31 fe ff ff       	call   49d <putc>
 66c:	83 c4 10             	add    $0x10,%esp
          s++;
 66f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 673:	8b 45 f4             	mov    -0xc(%ebp),%eax
 676:	0f b6 00             	movzbl (%eax),%eax
 679:	84 c0                	test   %al,%al
 67b:	75 da                	jne    657 <printf+0xe3>
 67d:	eb 65                	jmp    6e4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 683:	75 1d                	jne    6a2 <printf+0x12e>
        putc(fd, *ap);
 685:	8b 45 e8             	mov    -0x18(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	0f be c0             	movsbl %al,%eax
 68d:	83 ec 08             	sub    $0x8,%esp
 690:	50                   	push   %eax
 691:	ff 75 08             	pushl  0x8(%ebp)
 694:	e8 04 fe ff ff       	call   49d <putc>
 699:	83 c4 10             	add    $0x10,%esp
        ap++;
 69c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a0:	eb 42                	jmp    6e4 <printf+0x170>
      } else if(c == '%'){
 6a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a6:	75 17                	jne    6bf <printf+0x14b>
        putc(fd, c);
 6a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ab:	0f be c0             	movsbl %al,%eax
 6ae:	83 ec 08             	sub    $0x8,%esp
 6b1:	50                   	push   %eax
 6b2:	ff 75 08             	pushl  0x8(%ebp)
 6b5:	e8 e3 fd ff ff       	call   49d <putc>
 6ba:	83 c4 10             	add    $0x10,%esp
 6bd:	eb 25                	jmp    6e4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6bf:	83 ec 08             	sub    $0x8,%esp
 6c2:	6a 25                	push   $0x25
 6c4:	ff 75 08             	pushl  0x8(%ebp)
 6c7:	e8 d1 fd ff ff       	call   49d <putc>
 6cc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d2:	0f be c0             	movsbl %al,%eax
 6d5:	83 ec 08             	sub    $0x8,%esp
 6d8:	50                   	push   %eax
 6d9:	ff 75 08             	pushl  0x8(%ebp)
 6dc:	e8 bc fd ff ff       	call   49d <putc>
 6e1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6eb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ef:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f5:	01 d0                	add    %edx,%eax
 6f7:	0f b6 00             	movzbl (%eax),%eax
 6fa:	84 c0                	test   %al,%al
 6fc:	0f 85 94 fe ff ff    	jne    596 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 702:	90                   	nop
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
 708:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	83 e8 08             	sub    $0x8,%eax
 711:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	a1 34 0c 00 00       	mov    0xc34,%eax
 719:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71c:	eb 24                	jmp    742 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 726:	77 12                	ja     73a <free+0x35>
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72e:	77 24                	ja     754 <free+0x4f>
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 738:	77 1a                	ja     754 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 748:	76 d4                	jbe    71e <free+0x19>
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 752:	76 ca                	jbe    71e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	01 c2                	add    %eax,%edx
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	39 c2                	cmp    %eax,%edx
 76d:	75 24                	jne    793 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	8b 50 04             	mov    0x4(%eax),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	01 c2                	add    %eax,%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	8b 10                	mov    (%eax),%edx
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	89 10                	mov    %edx,(%eax)
 791:	eb 0a                	jmp    79d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	01 d0                	add    %edx,%eax
 7af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b2:	75 20                	jne    7d4 <free+0xcf>
    p->s.size += bp->s.size;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 50 04             	mov    0x4(%eax),%edx
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	01 c2                	add    %eax,%edx
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 10                	mov    (%eax),%edx
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	89 10                	mov    %edx,(%eax)
 7d2:	eb 08                	jmp    7dc <free+0xd7>
  } else
    p->s.ptr = bp;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7da:	89 10                	mov    %edx,(%eax)
  freep = p;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	a3 34 0c 00 00       	mov    %eax,0xc34
}
 7e4:	90                   	nop
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    

000007e7 <morecore>:

static Header*
morecore(uint nu)
{
 7e7:	55                   	push   %ebp
 7e8:	89 e5                	mov    %esp,%ebp
 7ea:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ed:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f4:	77 07                	ja     7fd <morecore+0x16>
    nu = 4096;
 7f6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	c1 e0 03             	shl    $0x3,%eax
 803:	83 ec 0c             	sub    $0xc,%esp
 806:	50                   	push   %eax
 807:	e8 39 fc ff ff       	call   445 <sbrk>
 80c:	83 c4 10             	add    $0x10,%esp
 80f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 812:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 816:	75 07                	jne    81f <morecore+0x38>
    return 0;
 818:	b8 00 00 00 00       	mov    $0x0,%eax
 81d:	eb 26                	jmp    845 <morecore+0x5e>
  hp = (Header*)p;
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	8b 55 08             	mov    0x8(%ebp),%edx
 82b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 831:	83 c0 08             	add    $0x8,%eax
 834:	83 ec 0c             	sub    $0xc,%esp
 837:	50                   	push   %eax
 838:	e8 c8 fe ff ff       	call   705 <free>
 83d:	83 c4 10             	add    $0x10,%esp
  return freep;
 840:	a1 34 0c 00 00       	mov    0xc34,%eax
}
 845:	c9                   	leave  
 846:	c3                   	ret    

00000847 <malloc>:

void*
malloc(uint nbytes)
{
 847:	55                   	push   %ebp
 848:	89 e5                	mov    %esp,%ebp
 84a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	83 c0 07             	add    $0x7,%eax
 853:	c1 e8 03             	shr    $0x3,%eax
 856:	83 c0 01             	add    $0x1,%eax
 859:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85c:	a1 34 0c 00 00       	mov    0xc34,%eax
 861:	89 45 f0             	mov    %eax,-0x10(%ebp)
 864:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 868:	75 23                	jne    88d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86a:	c7 45 f0 2c 0c 00 00 	movl   $0xc2c,-0x10(%ebp)
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	a3 34 0c 00 00       	mov    %eax,0xc34
 879:	a1 34 0c 00 00       	mov    0xc34,%eax
 87e:	a3 2c 0c 00 00       	mov    %eax,0xc2c
    base.s.size = 0;
 883:	c7 05 30 0c 00 00 00 	movl   $0x0,0xc30
 88a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 890:	8b 00                	mov    (%eax),%eax
 892:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 895:	8b 45 f4             	mov    -0xc(%ebp),%eax
 898:	8b 40 04             	mov    0x4(%eax),%eax
 89b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89e:	72 4d                	jb     8ed <malloc+0xa6>
      if(p->s.size == nunits)
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 40 04             	mov    0x4(%eax),%eax
 8a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a9:	75 0c                	jne    8b7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	8b 10                	mov    (%eax),%edx
 8b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b3:	89 10                	mov    %edx,(%eax)
 8b5:	eb 26                	jmp    8dd <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c0:	89 c2                	mov    %eax,%edx
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 40 04             	mov    0x4(%eax),%eax
 8ce:	c1 e0 03             	shl    $0x3,%eax
 8d1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8da:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e0:	a3 34 0c 00 00       	mov    %eax,0xc34
      return (void*)(p + 1);
 8e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e8:	83 c0 08             	add    $0x8,%eax
 8eb:	eb 3b                	jmp    928 <malloc+0xe1>
    }
    if(p == freep)
 8ed:	a1 34 0c 00 00       	mov    0xc34,%eax
 8f2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f5:	75 1e                	jne    915 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8f7:	83 ec 0c             	sub    $0xc,%esp
 8fa:	ff 75 ec             	pushl  -0x14(%ebp)
 8fd:	e8 e5 fe ff ff       	call   7e7 <morecore>
 902:	83 c4 10             	add    $0x10,%esp
 905:	89 45 f4             	mov    %eax,-0xc(%ebp)
 908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90c:	75 07                	jne    915 <malloc+0xce>
        return 0;
 90e:	b8 00 00 00 00       	mov    $0x0,%eax
 913:	eb 13                	jmp    928 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 923:	e9 6d ff ff ff       	jmp    895 <malloc+0x4e>
}
 928:	c9                   	leave  
 929:	c3                   	ret    
