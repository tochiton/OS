
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 05 09 00 00       	push   $0x905
  1b:	e8 bd 03 00 00       	call   3dd <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 05 09 00 00       	push   $0x905
  33:	e8 ad 03 00 00       	call   3e5 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 05 09 00 00       	push   $0x905
  45:	e8 93 03 00 00       	call   3dd <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 be 03 00 00       	call   415 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 b1 03 00 00       	call   415 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 0d 09 00 00       	push   $0x90d
  6f:	6a 01                	push   $0x1
  71:	e8 d6 04 00 00       	call   54c <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 17 03 00 00       	call   395 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 20 09 00 00       	push   $0x920
  8f:	6a 01                	push   $0x1
  91:	e8 b6 04 00 00       	call   54c <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 ff 02 00 00       	call   39d <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 a4 0b 00 00       	push   $0xba4
  ac:	68 02 09 00 00       	push   $0x902
  b1:	e8 1f 03 00 00       	call   3d5 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 33 09 00 00       	push   $0x933
  c1:	6a 01                	push   $0x1
  c3:	e8 84 04 00 00       	call   54c <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 cd 02 00 00       	call   39d <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 49 09 00 00       	push   $0x949
  d8:	6a 01                	push   $0x1
  da:	e8 6d 04 00 00       	call   54c <printf>
  df:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 be 02 00 00       	call   3a5 <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
      printf(1, "zombie!\n");
  }
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8d 50 01             	lea    0x1(%eax),%edx
 13a:	89 55 08             	mov    %edx,0x8(%ebp)
 13d:	8b 55 0c             	mov    0xc(%ebp),%edx
 140:	8d 4a 01             	lea    0x1(%edx),%ecx
 143:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <strlen>:

uint
strlen(char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	pushl  0xc(%ebp)
 1c7:	ff 75 08             	pushl  0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 8c 01 00 00       	call   3b5 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	3b 45 0c             	cmp    0xc(%ebp),%eax
 264:	7c b3                	jl     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 268:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <stat>:

int
stat(char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 51 01 00 00       	call   3dd <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	pushl  0xc(%ebp)
 2a5:	ff 75 f4             	pushl  -0xc(%ebp)
 2a8:	e8 48 01 00 00       	call   3f5 <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	pushl  -0xc(%ebp)
 2b9:	e8 07 01 00 00       	call   3c5 <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d3:	eb 04                	jmp    2d9 <atoi+0x13>
 2d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 20                	cmp    $0x20,%al
 2e1:	74 f2                	je     2d5 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 2d                	cmp    $0x2d,%al
 2eb:	75 07                	jne    2f4 <atoi+0x2e>
 2ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f2:	eb 05                	jmp    2f9 <atoi+0x33>
 2f4:	b8 01 00 00 00       	mov    $0x1,%eax
 2f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 2b                	cmp    $0x2b,%al
 304:	74 0a                	je     310 <atoi+0x4a>
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	3c 2d                	cmp    $0x2d,%al
 30e:	75 2b                	jne    33b <atoi+0x75>
    s++;
 310:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 314:	eb 25                	jmp    33b <atoi+0x75>
    n = n*10 + *s++ - '0';
 316:	8b 55 fc             	mov    -0x4(%ebp),%edx
 319:	89 d0                	mov    %edx,%eax
 31b:	c1 e0 02             	shl    $0x2,%eax
 31e:	01 d0                	add    %edx,%eax
 320:	01 c0                	add    %eax,%eax
 322:	89 c1                	mov    %eax,%ecx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8d 50 01             	lea    0x1(%eax),%edx
 32a:	89 55 08             	mov    %edx,0x8(%ebp)
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	0f be c0             	movsbl %al,%eax
 333:	01 c8                	add    %ecx,%eax
 335:	83 e8 30             	sub    $0x30,%eax
 338:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	0f b6 00             	movzbl (%eax),%eax
 341:	3c 2f                	cmp    $0x2f,%al
 343:	7e 0a                	jle    34f <atoi+0x89>
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	3c 39                	cmp    $0x39,%al
 34d:	7e c7                	jle    316 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 34f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 352:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 356:	c9                   	leave  
 357:	c3                   	ret    

00000358 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36a:	eb 17                	jmp    383 <memmove+0x2b>
    *dst++ = *src++;
 36c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36f:	8d 50 01             	lea    0x1(%eax),%edx
 372:	89 55 fc             	mov    %edx,-0x4(%ebp)
 375:	8b 55 f8             	mov    -0x8(%ebp),%edx
 378:	8d 4a 01             	lea    0x1(%edx),%ecx
 37b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 37e:	0f b6 12             	movzbl (%edx),%edx
 381:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 383:	8b 45 10             	mov    0x10(%ebp),%eax
 386:	8d 50 ff             	lea    -0x1(%eax),%edx
 389:	89 55 10             	mov    %edx,0x10(%ebp)
 38c:	85 c0                	test   %eax,%eax
 38e:	7f dc                	jg     36c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 390:	8b 45 08             	mov    0x8(%ebp),%eax
}
 393:	c9                   	leave  
 394:	c3                   	ret    

00000395 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 395:	b8 01 00 00 00       	mov    $0x1,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <exit>:
SYSCALL(exit)
 39d:	b8 02 00 00 00       	mov    $0x2,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <wait>:
SYSCALL(wait)
 3a5:	b8 03 00 00 00       	mov    $0x3,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <pipe>:
SYSCALL(pipe)
 3ad:	b8 04 00 00 00       	mov    $0x4,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <read>:
SYSCALL(read)
 3b5:	b8 05 00 00 00       	mov    $0x5,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <write>:
SYSCALL(write)
 3bd:	b8 10 00 00 00       	mov    $0x10,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <close>:
SYSCALL(close)
 3c5:	b8 15 00 00 00       	mov    $0x15,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <kill>:
SYSCALL(kill)
 3cd:	b8 06 00 00 00       	mov    $0x6,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <exec>:
SYSCALL(exec)
 3d5:	b8 07 00 00 00       	mov    $0x7,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <open>:
SYSCALL(open)
 3dd:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <mknod>:
SYSCALL(mknod)
 3e5:	b8 11 00 00 00       	mov    $0x11,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <unlink>:
SYSCALL(unlink)
 3ed:	b8 12 00 00 00       	mov    $0x12,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <fstat>:
SYSCALL(fstat)
 3f5:	b8 08 00 00 00       	mov    $0x8,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <link>:
SYSCALL(link)
 3fd:	b8 13 00 00 00       	mov    $0x13,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <mkdir>:
SYSCALL(mkdir)
 405:	b8 14 00 00 00       	mov    $0x14,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <chdir>:
SYSCALL(chdir)
 40d:	b8 09 00 00 00       	mov    $0x9,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <dup>:
SYSCALL(dup)
 415:	b8 0a 00 00 00       	mov    $0xa,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <getpid>:
SYSCALL(getpid)
 41d:	b8 0b 00 00 00       	mov    $0xb,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <sbrk>:
SYSCALL(sbrk)
 425:	b8 0c 00 00 00       	mov    $0xc,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <sleep>:
SYSCALL(sleep)
 42d:	b8 0d 00 00 00       	mov    $0xd,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <uptime>:
SYSCALL(uptime)
 435:	b8 0e 00 00 00       	mov    $0xe,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <halt>:
SYSCALL(halt)
 43d:	b8 16 00 00 00       	mov    $0x16,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <date>:
SYSCALL(date)
 445:	b8 17 00 00 00       	mov    $0x17,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <getuid>:
SYSCALL(getuid)
 44d:	b8 18 00 00 00       	mov    $0x18,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <getgid>:
SYSCALL(getgid)
 455:	b8 19 00 00 00       	mov    $0x19,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <getppid>:
SYSCALL(getppid)
 45d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <setuid>:
SYSCALL(setuid)
 465:	b8 1b 00 00 00       	mov    $0x1b,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <setgid>:
SYSCALL(setgid)
 46d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 475:	55                   	push   %ebp
 476:	89 e5                	mov    %esp,%ebp
 478:	83 ec 18             	sub    $0x18,%esp
 47b:	8b 45 0c             	mov    0xc(%ebp),%eax
 47e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 481:	83 ec 04             	sub    $0x4,%esp
 484:	6a 01                	push   $0x1
 486:	8d 45 f4             	lea    -0xc(%ebp),%eax
 489:	50                   	push   %eax
 48a:	ff 75 08             	pushl  0x8(%ebp)
 48d:	e8 2b ff ff ff       	call   3bd <write>
 492:	83 c4 10             	add    $0x10,%esp
}
 495:	90                   	nop
 496:	c9                   	leave  
 497:	c3                   	ret    

00000498 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	53                   	push   %ebx
 49c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 49f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4aa:	74 17                	je     4c3 <printint+0x2b>
 4ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b0:	79 11                	jns    4c3 <printint+0x2b>
    neg = 1;
 4b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	f7 d8                	neg    %eax
 4be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c1:	eb 06                	jmp    4c9 <printint+0x31>
  } else {
    x = xx;
 4c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4d3:	8d 41 01             	lea    0x1(%ecx),%eax
 4d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4df:	ba 00 00 00 00       	mov    $0x0,%edx
 4e4:	f7 f3                	div    %ebx
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	0f b6 80 ac 0b 00 00 	movzbl 0xbac(%eax),%eax
 4ef:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f9:	ba 00 00 00 00       	mov    $0x0,%edx
 4fe:	f7 f3                	div    %ebx
 500:	89 45 ec             	mov    %eax,-0x14(%ebp)
 503:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 507:	75 c7                	jne    4d0 <printint+0x38>
  if(neg)
 509:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 50d:	74 2d                	je     53c <printint+0xa4>
    buf[i++] = '-';
 50f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 512:	8d 50 01             	lea    0x1(%eax),%edx
 515:	89 55 f4             	mov    %edx,-0xc(%ebp)
 518:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 51d:	eb 1d                	jmp    53c <printint+0xa4>
    putc(fd, buf[i]);
 51f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 522:	8b 45 f4             	mov    -0xc(%ebp),%eax
 525:	01 d0                	add    %edx,%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	50                   	push   %eax
 531:	ff 75 08             	pushl  0x8(%ebp)
 534:	e8 3c ff ff ff       	call   475 <putc>
 539:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 53c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 544:	79 d9                	jns    51f <printint+0x87>
    putc(fd, buf[i]);
}
 546:	90                   	nop
 547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 54a:	c9                   	leave  
 54b:	c3                   	ret    

0000054c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 552:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 559:	8d 45 0c             	lea    0xc(%ebp),%eax
 55c:	83 c0 04             	add    $0x4,%eax
 55f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 562:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 569:	e9 59 01 00 00       	jmp    6c7 <printf+0x17b>
    c = fmt[i] & 0xff;
 56e:	8b 55 0c             	mov    0xc(%ebp),%edx
 571:	8b 45 f0             	mov    -0x10(%ebp),%eax
 574:	01 d0                	add    %edx,%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	25 ff 00 00 00       	and    $0xff,%eax
 581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 584:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 588:	75 2c                	jne    5b6 <printf+0x6a>
      if(c == '%'){
 58a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58e:	75 0c                	jne    59c <printf+0x50>
        state = '%';
 590:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 597:	e9 27 01 00 00       	jmp    6c3 <printf+0x177>
      } else {
        putc(fd, c);
 59c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59f:	0f be c0             	movsbl %al,%eax
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	50                   	push   %eax
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 c7 fe ff ff       	call   475 <putc>
 5ae:	83 c4 10             	add    $0x10,%esp
 5b1:	e9 0d 01 00 00       	jmp    6c3 <printf+0x177>
      }
    } else if(state == '%'){
 5b6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ba:	0f 85 03 01 00 00    	jne    6c3 <printf+0x177>
      if(c == 'd'){
 5c0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5c4:	75 1e                	jne    5e4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c9:	8b 00                	mov    (%eax),%eax
 5cb:	6a 01                	push   $0x1
 5cd:	6a 0a                	push   $0xa
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	pushl  0x8(%ebp)
 5d3:	e8 c0 fe ff ff       	call   498 <printint>
 5d8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5df:	e9 d8 00 00 00       	jmp    6bc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5e4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e8:	74 06                	je     5f0 <printf+0xa4>
 5ea:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ee:	75 1e                	jne    60e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	6a 00                	push   $0x0
 5f7:	6a 10                	push   $0x10
 5f9:	50                   	push   %eax
 5fa:	ff 75 08             	pushl  0x8(%ebp)
 5fd:	e8 96 fe ff ff       	call   498 <printint>
 602:	83 c4 10             	add    $0x10,%esp
        ap++;
 605:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 609:	e9 ae 00 00 00       	jmp    6bc <printf+0x170>
      } else if(c == 's'){
 60e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 612:	75 43                	jne    657 <printf+0x10b>
        s = (char*)*ap;
 614:	8b 45 e8             	mov    -0x18(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 624:	75 25                	jne    64b <printf+0xff>
          s = "(null)";
 626:	c7 45 f4 52 09 00 00 	movl   $0x952,-0xc(%ebp)
        while(*s != 0){
 62d:	eb 1c                	jmp    64b <printf+0xff>
          putc(fd, *s);
 62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 632:	0f b6 00             	movzbl (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 31 fe ff ff       	call   475 <putc>
 644:	83 c4 10             	add    $0x10,%esp
          s++;
 647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64e:	0f b6 00             	movzbl (%eax),%eax
 651:	84 c0                	test   %al,%al
 653:	75 da                	jne    62f <printf+0xe3>
 655:	eb 65                	jmp    6bc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 657:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65b:	75 1d                	jne    67a <printf+0x12e>
        putc(fd, *ap);
 65d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	0f be c0             	movsbl %al,%eax
 665:	83 ec 08             	sub    $0x8,%esp
 668:	50                   	push   %eax
 669:	ff 75 08             	pushl  0x8(%ebp)
 66c:	e8 04 fe ff ff       	call   475 <putc>
 671:	83 c4 10             	add    $0x10,%esp
        ap++;
 674:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 678:	eb 42                	jmp    6bc <printf+0x170>
      } else if(c == '%'){
 67a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67e:	75 17                	jne    697 <printf+0x14b>
        putc(fd, c);
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	83 ec 08             	sub    $0x8,%esp
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 e3 fd ff ff       	call   475 <putc>
 692:	83 c4 10             	add    $0x10,%esp
 695:	eb 25                	jmp    6bc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 697:	83 ec 08             	sub    $0x8,%esp
 69a:	6a 25                	push   $0x25
 69c:	ff 75 08             	pushl  0x8(%ebp)
 69f:	e8 d1 fd ff ff       	call   475 <putc>
 6a4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6aa:	0f be c0             	movsbl %al,%eax
 6ad:	83 ec 08             	sub    $0x8,%esp
 6b0:	50                   	push   %eax
 6b1:	ff 75 08             	pushl  0x8(%ebp)
 6b4:	e8 bc fd ff ff       	call   475 <putc>
 6b9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cd:	01 d0                	add    %edx,%eax
 6cf:	0f b6 00             	movzbl (%eax),%eax
 6d2:	84 c0                	test   %al,%al
 6d4:	0f 85 94 fe ff ff    	jne    56e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6da:	90                   	nop
 6db:	c9                   	leave  
 6dc:	c3                   	ret    

000006dd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6dd:	55                   	push   %ebp
 6de:	89 e5                	mov    %esp,%ebp
 6e0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	83 e8 08             	sub    $0x8,%eax
 6e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 6f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f4:	eb 24                	jmp    71a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fe:	77 12                	ja     712 <free+0x35>
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 706:	77 24                	ja     72c <free+0x4f>
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 710:	77 1a                	ja     72c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 00                	mov    (%eax),%eax
 717:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 720:	76 d4                	jbe    6f6 <free+0x19>
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72a:	76 ca                	jbe    6f6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	8b 40 04             	mov    0x4(%eax),%eax
 732:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	01 c2                	add    %eax,%edx
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	39 c2                	cmp    %eax,%edx
 745:	75 24                	jne    76b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	8b 50 04             	mov    0x4(%eax),%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	8b 40 04             	mov    0x4(%eax),%eax
 755:	01 c2                	add    %eax,%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	8b 10                	mov    (%eax),%edx
 764:	8b 45 f8             	mov    -0x8(%ebp),%eax
 767:	89 10                	mov    %edx,(%eax)
 769:	eb 0a                	jmp    775 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 40 04             	mov    0x4(%eax),%eax
 77b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	01 d0                	add    %edx,%eax
 787:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78a:	75 20                	jne    7ac <free+0xcf>
    p->s.size += bp->s.size;
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 50 04             	mov    0x4(%eax),%edx
 792:	8b 45 f8             	mov    -0x8(%ebp),%eax
 795:	8b 40 04             	mov    0x4(%eax),%eax
 798:	01 c2                	add    %eax,%edx
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a3:	8b 10                	mov    (%eax),%edx
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	89 10                	mov    %edx,(%eax)
 7aa:	eb 08                	jmp    7b4 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b2:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 7bc:	90                   	nop
 7bd:	c9                   	leave  
 7be:	c3                   	ret    

000007bf <morecore>:

static Header*
morecore(uint nu)
{
 7bf:	55                   	push   %ebp
 7c0:	89 e5                	mov    %esp,%ebp
 7c2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7cc:	77 07                	ja     7d5 <morecore+0x16>
    nu = 4096;
 7ce:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d5:	8b 45 08             	mov    0x8(%ebp),%eax
 7d8:	c1 e0 03             	shl    $0x3,%eax
 7db:	83 ec 0c             	sub    $0xc,%esp
 7de:	50                   	push   %eax
 7df:	e8 41 fc ff ff       	call   425 <sbrk>
 7e4:	83 c4 10             	add    $0x10,%esp
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ea:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ee:	75 07                	jne    7f7 <morecore+0x38>
    return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 26                	jmp    81d <morecore+0x5e>
  hp = (Header*)p;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	8b 55 08             	mov    0x8(%ebp),%edx
 803:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	83 c0 08             	add    $0x8,%eax
 80c:	83 ec 0c             	sub    $0xc,%esp
 80f:	50                   	push   %eax
 810:	e8 c8 fe ff ff       	call   6dd <free>
 815:	83 c4 10             	add    $0x10,%esp
  return freep;
 818:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <malloc>:

void*
malloc(uint nbytes)
{
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	83 c0 07             	add    $0x7,%eax
 82b:	c1 e8 03             	shr    $0x3,%eax
 82e:	83 c0 01             	add    $0x1,%eax
 831:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 834:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 839:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 840:	75 23                	jne    865 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 842:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 851:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 856:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 85b:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 862:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 40 04             	mov    0x4(%eax),%eax
 873:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 876:	72 4d                	jb     8c5 <malloc+0xa6>
      if(p->s.size == nunits)
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	8b 40 04             	mov    0x4(%eax),%eax
 87e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 881:	75 0c                	jne    88f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 10                	mov    (%eax),%edx
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	89 10                	mov    %edx,(%eax)
 88d:	eb 26                	jmp    8b5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	2b 45 ec             	sub    -0x14(%ebp),%eax
 898:	89 c2                	mov    %eax,%edx
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 40 04             	mov    0x4(%eax),%eax
 8a6:	c1 e0 03             	shl    $0x3,%eax
 8a9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	83 c0 08             	add    $0x8,%eax
 8c3:	eb 3b                	jmp    900 <malloc+0xe1>
    }
    if(p == freep)
 8c5:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 8ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8cd:	75 1e                	jne    8ed <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8cf:	83 ec 0c             	sub    $0xc,%esp
 8d2:	ff 75 ec             	pushl  -0x14(%ebp)
 8d5:	e8 e5 fe ff ff       	call   7bf <morecore>
 8da:	83 c4 10             	add    $0x10,%esp
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e4:	75 07                	jne    8ed <malloc+0xce>
        return 0;
 8e6:	b8 00 00 00 00       	mov    $0x0,%eax
 8eb:	eb 13                	jmp    900 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	8b 00                	mov    (%eax),%eax
 8f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8fb:	e9 6d ff ff ff       	jmp    86d <malloc+0x4e>
}
 900:	c9                   	leave  
 901:	c3                   	ret    
