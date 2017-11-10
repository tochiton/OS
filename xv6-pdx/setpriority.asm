
_setpriority:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int pid = atoi(argv[1]);	
  14:	8b 43 04             	mov    0x4(%ebx),%eax
  17:	83 c0 04             	add    $0x4,%eax
  1a:	8b 00                	mov    (%eax),%eax
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	50                   	push   %eax
  20:	e8 3f 02 00 00       	call   264 <atoi>
  25:	83 c4 10             	add    $0x10,%esp
  28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int priority = atoi(argv[2]);	
  2b:	8b 43 04             	mov    0x4(%ebx),%eax
  2e:	83 c0 08             	add    $0x8,%eax
  31:	8b 00                	mov    (%eax),%eax
  33:	83 ec 0c             	sub    $0xc,%esp
  36:	50                   	push   %eax
  37:	e8 28 02 00 00       	call   264 <atoi>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"testing setting priority %d...%d\n", pid, priority);
  42:	ff 75 f0             	pushl  -0x10(%ebp)
  45:	ff 75 f4             	pushl  -0xc(%ebp)
  48:	68 b0 08 00 00       	push   $0x8b0
  4d:	6a 01                	push   $0x1
  4f:	e8 a6 04 00 00       	call   4fa <printf>
  54:	83 c4 10             	add    $0x10,%esp
  int rc = setpriority(pid, priority);
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 75 f0             	pushl  -0x10(%ebp)
  5d:	ff 75 f4             	pushl  -0xc(%ebp)
  60:	e8 b6 03 00 00       	call   41b <setpriority>
  65:	83 c4 10             	add    $0x10,%esp
  68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(rc == -1){
  6b:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  6f:	75 14                	jne    85 <main+0x85>
  	printf(1, "Invalid argument\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 d2 08 00 00       	push   $0x8d2
  79:	6a 01                	push   $0x1
  7b:	e8 7a 04 00 00       	call   4fa <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	eb 15                	jmp    9a <main+0x9a>
  }else{
  	printf(1,"The RC values is: %d\n", rc);	
  85:	83 ec 04             	sub    $0x4,%esp
  88:	ff 75 ec             	pushl  -0x14(%ebp)
  8b:	68 e4 08 00 00       	push   $0x8e4
  90:	6a 01                	push   $0x1
  92:	e8 63 04 00 00       	call   4fa <printf>
  97:	83 c4 10             	add    $0x10,%esp
  }	
  //printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  exit();
  9a:	e8 9c 02 00 00       	call   33b <exit>

0000009f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	57                   	push   %edi
  a3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a7:	8b 55 10             	mov    0x10(%ebp),%edx
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  ad:	89 cb                	mov    %ecx,%ebx
  af:	89 df                	mov    %ebx,%edi
  b1:	89 d1                	mov    %edx,%ecx
  b3:	fc                   	cld    
  b4:	f3 aa                	rep stos %al,%es:(%edi)
  b6:	89 ca                	mov    %ecx,%edx
  b8:	89 fb                	mov    %edi,%ebx
  ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
  bd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c0:	90                   	nop
  c1:	5b                   	pop    %ebx
  c2:	5f                   	pop    %edi
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  cb:	8b 45 08             	mov    0x8(%ebp),%eax
  ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d1:	90                   	nop
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	8d 50 01             	lea    0x1(%eax),%edx
  d8:	89 55 08             	mov    %edx,0x8(%ebp)
  db:	8b 55 0c             	mov    0xc(%ebp),%edx
  de:	8d 4a 01             	lea    0x1(%edx),%ecx
  e1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  e4:	0f b6 12             	movzbl (%edx),%edx
  e7:	88 10                	mov    %dl,(%eax)
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	84 c0                	test   %al,%al
  ee:	75 e2                	jne    d2 <strcpy+0xd>
    ;
  return os;
  f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f3:	c9                   	leave  
  f4:	c3                   	ret    

000000f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f5:	55                   	push   %ebp
  f6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f8:	eb 08                	jmp    102 <strcmp+0xd>
    p++, q++;
  fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	84 c0                	test   %al,%al
 10a:	74 10                	je     11c <strcmp+0x27>
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 10             	movzbl (%eax),%edx
 112:	8b 45 0c             	mov    0xc(%ebp),%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	38 c2                	cmp    %al,%dl
 11a:	74 de                	je     fa <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	0f b6 d0             	movzbl %al,%edx
 125:	8b 45 0c             	mov    0xc(%ebp),%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	0f b6 c0             	movzbl %al,%eax
 12e:	29 c2                	sub    %eax,%edx
 130:	89 d0                	mov    %edx,%eax
}
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    

00000134 <strlen>:

uint
strlen(char *s)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 13a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 141:	eb 04                	jmp    147 <strlen+0x13>
 143:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 147:	8b 55 fc             	mov    -0x4(%ebp),%edx
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
 14d:	01 d0                	add    %edx,%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	84 c0                	test   %al,%al
 154:	75 ed                	jne    143 <strlen+0xf>
    ;
  return n;
 156:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 159:	c9                   	leave  
 15a:	c3                   	ret    

0000015b <memset>:

void*
memset(void *dst, int c, uint n)
{
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 15e:	8b 45 10             	mov    0x10(%ebp),%eax
 161:	50                   	push   %eax
 162:	ff 75 0c             	pushl  0xc(%ebp)
 165:	ff 75 08             	pushl  0x8(%ebp)
 168:	e8 32 ff ff ff       	call   9f <stosb>
 16d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 170:	8b 45 08             	mov    0x8(%ebp),%eax
}
 173:	c9                   	leave  
 174:	c3                   	ret    

00000175 <strchr>:

char*
strchr(const char *s, char c)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	83 ec 04             	sub    $0x4,%esp
 17b:	8b 45 0c             	mov    0xc(%ebp),%eax
 17e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 181:	eb 14                	jmp    197 <strchr+0x22>
    if(*s == c)
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18c:	75 05                	jne    193 <strchr+0x1e>
      return (char*)s;
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	eb 13                	jmp    1a6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 193:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 e2                	jne    183 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <gets>:

char*
gets(char *buf, int max)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b5:	eb 42                	jmp    1f9 <gets+0x51>
    cc = read(0, &c, 1);
 1b7:	83 ec 04             	sub    $0x4,%esp
 1ba:	6a 01                	push   $0x1
 1bc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1bf:	50                   	push   %eax
 1c0:	6a 00                	push   $0x0
 1c2:	e8 8c 01 00 00       	call   353 <read>
 1c7:	83 c4 10             	add    $0x10,%esp
 1ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d1:	7e 33                	jle    206 <gets+0x5e>
      break;
    buf[i++] = c;
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	8d 50 01             	lea    0x1(%eax),%edx
 1d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1dc:	89 c2                	mov    %eax,%edx
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	01 c2                	add    %eax,%edx
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ed:	3c 0a                	cmp    $0xa,%al
 1ef:	74 16                	je     207 <gets+0x5f>
 1f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f5:	3c 0d                	cmp    $0xd,%al
 1f7:	74 0e                	je     207 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fc:	83 c0 01             	add    $0x1,%eax
 1ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
 202:	7c b3                	jl     1b7 <gets+0xf>
 204:	eb 01                	jmp    207 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 206:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 207:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
}
 215:	c9                   	leave  
 216:	c3                   	ret    

00000217 <stat>:

int
stat(char *n, struct stat *st)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21d:	83 ec 08             	sub    $0x8,%esp
 220:	6a 00                	push   $0x0
 222:	ff 75 08             	pushl  0x8(%ebp)
 225:	e8 51 01 00 00       	call   37b <open>
 22a:	83 c4 10             	add    $0x10,%esp
 22d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 234:	79 07                	jns    23d <stat+0x26>
    return -1;
 236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 23b:	eb 25                	jmp    262 <stat+0x4b>
  r = fstat(fd, st);
 23d:	83 ec 08             	sub    $0x8,%esp
 240:	ff 75 0c             	pushl  0xc(%ebp)
 243:	ff 75 f4             	pushl  -0xc(%ebp)
 246:	e8 48 01 00 00       	call   393 <fstat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 251:	83 ec 0c             	sub    $0xc,%esp
 254:	ff 75 f4             	pushl  -0xc(%ebp)
 257:	e8 07 01 00 00       	call   363 <close>
 25c:	83 c4 10             	add    $0x10,%esp
  return r;
 25f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 262:	c9                   	leave  
 263:	c3                   	ret    

00000264 <atoi>:

int
atoi(const char *s)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 26a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 271:	eb 04                	jmp    277 <atoi+0x13>
 273:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 20                	cmp    $0x20,%al
 27f:	74 f2                	je     273 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2d                	cmp    $0x2d,%al
 289:	75 07                	jne    292 <atoi+0x2e>
 28b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 290:	eb 05                	jmp    297 <atoi+0x33>
 292:	b8 01 00 00 00       	mov    $0x1,%eax
 297:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	0f b6 00             	movzbl (%eax),%eax
 2a0:	3c 2b                	cmp    $0x2b,%al
 2a2:	74 0a                	je     2ae <atoi+0x4a>
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	3c 2d                	cmp    $0x2d,%al
 2ac:	75 2b                	jne    2d9 <atoi+0x75>
    s++;
 2ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2b2:	eb 25                	jmp    2d9 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b7:	89 d0                	mov    %edx,%eax
 2b9:	c1 e0 02             	shl    $0x2,%eax
 2bc:	01 d0                	add    %edx,%eax
 2be:	01 c0                	add    %eax,%eax
 2c0:	89 c1                	mov    %eax,%ecx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 08             	mov    %edx,0x8(%ebp)
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	0f be c0             	movsbl %al,%eax
 2d1:	01 c8                	add    %ecx,%eax
 2d3:	83 e8 30             	sub    $0x30,%eax
 2d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 2f                	cmp    $0x2f,%al
 2e1:	7e 0a                	jle    2ed <atoi+0x89>
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 39                	cmp    $0x39,%al
 2eb:	7e c7                	jle    2b4 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2f0:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 308:	eb 17                	jmp    321 <memmove+0x2b>
    *dst++ = *src++;
 30a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 30d:	8d 50 01             	lea    0x1(%eax),%edx
 310:	89 55 fc             	mov    %edx,-0x4(%ebp)
 313:	8b 55 f8             	mov    -0x8(%ebp),%edx
 316:	8d 4a 01             	lea    0x1(%edx),%ecx
 319:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 31c:	0f b6 12             	movzbl (%edx),%edx
 31f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 321:	8b 45 10             	mov    0x10(%ebp),%eax
 324:	8d 50 ff             	lea    -0x1(%eax),%edx
 327:	89 55 10             	mov    %edx,0x10(%ebp)
 32a:	85 c0                	test   %eax,%eax
 32c:	7f dc                	jg     30a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 331:	c9                   	leave  
 332:	c3                   	ret    

00000333 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 333:	b8 01 00 00 00       	mov    $0x1,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <exit>:
SYSCALL(exit)
 33b:	b8 02 00 00 00       	mov    $0x2,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <wait>:
SYSCALL(wait)
 343:	b8 03 00 00 00       	mov    $0x3,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <pipe>:
SYSCALL(pipe)
 34b:	b8 04 00 00 00       	mov    $0x4,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <read>:
SYSCALL(read)
 353:	b8 05 00 00 00       	mov    $0x5,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <write>:
SYSCALL(write)
 35b:	b8 10 00 00 00       	mov    $0x10,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <close>:
SYSCALL(close)
 363:	b8 15 00 00 00       	mov    $0x15,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <kill>:
SYSCALL(kill)
 36b:	b8 06 00 00 00       	mov    $0x6,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <exec>:
SYSCALL(exec)
 373:	b8 07 00 00 00       	mov    $0x7,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <open>:
SYSCALL(open)
 37b:	b8 0f 00 00 00       	mov    $0xf,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <mknod>:
SYSCALL(mknod)
 383:	b8 11 00 00 00       	mov    $0x11,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <unlink>:
SYSCALL(unlink)
 38b:	b8 12 00 00 00       	mov    $0x12,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <fstat>:
SYSCALL(fstat)
 393:	b8 08 00 00 00       	mov    $0x8,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <link>:
SYSCALL(link)
 39b:	b8 13 00 00 00       	mov    $0x13,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <mkdir>:
SYSCALL(mkdir)
 3a3:	b8 14 00 00 00       	mov    $0x14,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <chdir>:
SYSCALL(chdir)
 3ab:	b8 09 00 00 00       	mov    $0x9,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <dup>:
SYSCALL(dup)
 3b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <getpid>:
SYSCALL(getpid)
 3bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <sbrk>:
SYSCALL(sbrk)
 3c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <sleep>:
SYSCALL(sleep)
 3cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <uptime>:
SYSCALL(uptime)
 3d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <halt>:
SYSCALL(halt)
 3db:	b8 16 00 00 00       	mov    $0x16,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <date>:
SYSCALL(date)
 3e3:	b8 17 00 00 00       	mov    $0x17,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <getuid>:
SYSCALL(getuid)
 3eb:	b8 18 00 00 00       	mov    $0x18,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <getgid>:
SYSCALL(getgid)
 3f3:	b8 19 00 00 00       	mov    $0x19,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <getppid>:
SYSCALL(getppid)
 3fb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <setuid>:
SYSCALL(setuid)
 403:	b8 1b 00 00 00       	mov    $0x1b,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <setgid>:
SYSCALL(setgid)
 40b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <getprocs>:
SYSCALL(getprocs)
 413:	b8 1d 00 00 00       	mov    $0x1d,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <setpriority>:
SYSCALL(setpriority)
 41b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 423:	55                   	push   %ebp
 424:	89 e5                	mov    %esp,%ebp
 426:	83 ec 18             	sub    $0x18,%esp
 429:	8b 45 0c             	mov    0xc(%ebp),%eax
 42c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 42f:	83 ec 04             	sub    $0x4,%esp
 432:	6a 01                	push   $0x1
 434:	8d 45 f4             	lea    -0xc(%ebp),%eax
 437:	50                   	push   %eax
 438:	ff 75 08             	pushl  0x8(%ebp)
 43b:	e8 1b ff ff ff       	call   35b <write>
 440:	83 c4 10             	add    $0x10,%esp
}
 443:	90                   	nop
 444:	c9                   	leave  
 445:	c3                   	ret    

00000446 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 446:	55                   	push   %ebp
 447:	89 e5                	mov    %esp,%ebp
 449:	53                   	push   %ebx
 44a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 454:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 458:	74 17                	je     471 <printint+0x2b>
 45a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45e:	79 11                	jns    471 <printint+0x2b>
    neg = 1;
 460:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	f7 d8                	neg    %eax
 46c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46f:	eb 06                	jmp    477 <printint+0x31>
  } else {
    x = xx;
 471:	8b 45 0c             	mov    0xc(%ebp),%eax
 474:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 477:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 481:	8d 41 01             	lea    0x1(%ecx),%eax
 484:	89 45 f4             	mov    %eax,-0xc(%ebp)
 487:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48d:	ba 00 00 00 00       	mov    $0x0,%edx
 492:	f7 f3                	div    %ebx
 494:	89 d0                	mov    %edx,%eax
 496:	0f b6 80 50 0b 00 00 	movzbl 0xb50(%eax),%eax
 49d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a7:	ba 00 00 00 00       	mov    $0x0,%edx
 4ac:	f7 f3                	div    %ebx
 4ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b5:	75 c7                	jne    47e <printint+0x38>
  if(neg)
 4b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bb:	74 2d                	je     4ea <printint+0xa4>
    buf[i++] = '-';
 4bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c0:	8d 50 01             	lea    0x1(%eax),%edx
 4c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4cb:	eb 1d                	jmp    4ea <printint+0xa4>
    putc(fd, buf[i]);
 4cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d3:	01 d0                	add    %edx,%eax
 4d5:	0f b6 00             	movzbl (%eax),%eax
 4d8:	0f be c0             	movsbl %al,%eax
 4db:	83 ec 08             	sub    $0x8,%esp
 4de:	50                   	push   %eax
 4df:	ff 75 08             	pushl  0x8(%ebp)
 4e2:	e8 3c ff ff ff       	call   423 <putc>
 4e7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ea:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f2:	79 d9                	jns    4cd <printint+0x87>
    putc(fd, buf[i]);
}
 4f4:	90                   	nop
 4f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f8:	c9                   	leave  
 4f9:	c3                   	ret    

000004fa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4fa:	55                   	push   %ebp
 4fb:	89 e5                	mov    %esp,%ebp
 4fd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 500:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 507:	8d 45 0c             	lea    0xc(%ebp),%eax
 50a:	83 c0 04             	add    $0x4,%eax
 50d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 517:	e9 59 01 00 00       	jmp    675 <printf+0x17b>
    c = fmt[i] & 0xff;
 51c:	8b 55 0c             	mov    0xc(%ebp),%edx
 51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 522:	01 d0                	add    %edx,%eax
 524:	0f b6 00             	movzbl (%eax),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	25 ff 00 00 00       	and    $0xff,%eax
 52f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 532:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 536:	75 2c                	jne    564 <printf+0x6a>
      if(c == '%'){
 538:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53c:	75 0c                	jne    54a <printf+0x50>
        state = '%';
 53e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 545:	e9 27 01 00 00       	jmp    671 <printf+0x177>
      } else {
        putc(fd, c);
 54a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54d:	0f be c0             	movsbl %al,%eax
 550:	83 ec 08             	sub    $0x8,%esp
 553:	50                   	push   %eax
 554:	ff 75 08             	pushl  0x8(%ebp)
 557:	e8 c7 fe ff ff       	call   423 <putc>
 55c:	83 c4 10             	add    $0x10,%esp
 55f:	e9 0d 01 00 00       	jmp    671 <printf+0x177>
      }
    } else if(state == '%'){
 564:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 568:	0f 85 03 01 00 00    	jne    671 <printf+0x177>
      if(c == 'd'){
 56e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 572:	75 1e                	jne    592 <printf+0x98>
        printint(fd, *ap, 10, 1);
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	6a 01                	push   $0x1
 57b:	6a 0a                	push   $0xa
 57d:	50                   	push   %eax
 57e:	ff 75 08             	pushl  0x8(%ebp)
 581:	e8 c0 fe ff ff       	call   446 <printint>
 586:	83 c4 10             	add    $0x10,%esp
        ap++;
 589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58d:	e9 d8 00 00 00       	jmp    66a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 592:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 596:	74 06                	je     59e <printf+0xa4>
 598:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 59c:	75 1e                	jne    5bc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 59e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a1:	8b 00                	mov    (%eax),%eax
 5a3:	6a 00                	push   $0x0
 5a5:	6a 10                	push   $0x10
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	pushl  0x8(%ebp)
 5ab:	e8 96 fe ff ff       	call   446 <printint>
 5b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b7:	e9 ae 00 00 00       	jmp    66a <printf+0x170>
      } else if(c == 's'){
 5bc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c0:	75 43                	jne    605 <printf+0x10b>
        s = (char*)*ap;
 5c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c5:	8b 00                	mov    (%eax),%eax
 5c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d2:	75 25                	jne    5f9 <printf+0xff>
          s = "(null)";
 5d4:	c7 45 f4 fa 08 00 00 	movl   $0x8fa,-0xc(%ebp)
        while(*s != 0){
 5db:	eb 1c                	jmp    5f9 <printf+0xff>
          putc(fd, *s);
 5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e0:	0f b6 00             	movzbl (%eax),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	83 ec 08             	sub    $0x8,%esp
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 31 fe ff ff       	call   423 <putc>
 5f2:	83 c4 10             	add    $0x10,%esp
          s++;
 5f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fc:	0f b6 00             	movzbl (%eax),%eax
 5ff:	84 c0                	test   %al,%al
 601:	75 da                	jne    5dd <printf+0xe3>
 603:	eb 65                	jmp    66a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 605:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 609:	75 1d                	jne    628 <printf+0x12e>
        putc(fd, *ap);
 60b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 04 fe ff ff       	call   423 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
        ap++;
 622:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 626:	eb 42                	jmp    66a <printf+0x170>
      } else if(c == '%'){
 628:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62c:	75 17                	jne    645 <printf+0x14b>
        putc(fd, c);
 62e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 631:	0f be c0             	movsbl %al,%eax
 634:	83 ec 08             	sub    $0x8,%esp
 637:	50                   	push   %eax
 638:	ff 75 08             	pushl  0x8(%ebp)
 63b:	e8 e3 fd ff ff       	call   423 <putc>
 640:	83 c4 10             	add    $0x10,%esp
 643:	eb 25                	jmp    66a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 645:	83 ec 08             	sub    $0x8,%esp
 648:	6a 25                	push   $0x25
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 d1 fd ff ff       	call   423 <putc>
 652:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	83 ec 08             	sub    $0x8,%esp
 65e:	50                   	push   %eax
 65f:	ff 75 08             	pushl  0x8(%ebp)
 662:	e8 bc fd ff ff       	call   423 <putc>
 667:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 66a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 671:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 675:	8b 55 0c             	mov    0xc(%ebp),%edx
 678:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67b:	01 d0                	add    %edx,%eax
 67d:	0f b6 00             	movzbl (%eax),%eax
 680:	84 c0                	test   %al,%al
 682:	0f 85 94 fe ff ff    	jne    51c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 688:	90                   	nop
 689:	c9                   	leave  
 68a:	c3                   	ret    

0000068b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68b:	55                   	push   %ebp
 68c:	89 e5                	mov    %esp,%ebp
 68e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 691:	8b 45 08             	mov    0x8(%ebp),%eax
 694:	83 e8 08             	sub    $0x8,%eax
 697:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69a:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 69f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a2:	eb 24                	jmp    6c8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ac:	77 12                	ja     6c0 <free+0x35>
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b4:	77 24                	ja     6da <free+0x4f>
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6be:	77 1a                	ja     6da <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ce:	76 d4                	jbe    6a4 <free+0x19>
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d8:	76 ca                	jbe    6a4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	8b 40 04             	mov    0x4(%eax),%eax
 6e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	01 c2                	add    %eax,%edx
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 00                	mov    (%eax),%eax
 6f1:	39 c2                	cmp    %eax,%edx
 6f3:	75 24                	jne    719 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	8b 50 04             	mov    0x4(%eax),%edx
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	8b 40 04             	mov    0x4(%eax),%eax
 703:	01 c2                	add    %eax,%edx
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	8b 10                	mov    (%eax),%edx
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	89 10                	mov    %edx,(%eax)
 717:	eb 0a                	jmp    723 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 10                	mov    (%eax),%edx
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 40 04             	mov    0x4(%eax),%eax
 729:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	01 d0                	add    %edx,%eax
 735:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 738:	75 20                	jne    75a <free+0xcf>
    p->s.size += bp->s.size;
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 50 04             	mov    0x4(%eax),%edx
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	01 c2                	add    %eax,%edx
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 08                	jmp    762 <free+0xd7>
  } else
    p->s.ptr = bp;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 760:	89 10                	mov    %edx,(%eax)
  freep = p;
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	a3 6c 0b 00 00       	mov    %eax,0xb6c
}
 76a:	90                   	nop
 76b:	c9                   	leave  
 76c:	c3                   	ret    

0000076d <morecore>:

static Header*
morecore(uint nu)
{
 76d:	55                   	push   %ebp
 76e:	89 e5                	mov    %esp,%ebp
 770:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 773:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 77a:	77 07                	ja     783 <morecore+0x16>
    nu = 4096;
 77c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 783:	8b 45 08             	mov    0x8(%ebp),%eax
 786:	c1 e0 03             	shl    $0x3,%eax
 789:	83 ec 0c             	sub    $0xc,%esp
 78c:	50                   	push   %eax
 78d:	e8 31 fc ff ff       	call   3c3 <sbrk>
 792:	83 c4 10             	add    $0x10,%esp
 795:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 798:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 79c:	75 07                	jne    7a5 <morecore+0x38>
    return 0;
 79e:	b8 00 00 00 00       	mov    $0x0,%eax
 7a3:	eb 26                	jmp    7cb <morecore+0x5e>
  hp = (Header*)p;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	8b 55 08             	mov    0x8(%ebp),%edx
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	83 c0 08             	add    $0x8,%eax
 7ba:	83 ec 0c             	sub    $0xc,%esp
 7bd:	50                   	push   %eax
 7be:	e8 c8 fe ff ff       	call   68b <free>
 7c3:	83 c4 10             	add    $0x10,%esp
  return freep;
 7c6:	a1 6c 0b 00 00       	mov    0xb6c,%eax
}
 7cb:	c9                   	leave  
 7cc:	c3                   	ret    

000007cd <malloc>:

void*
malloc(uint nbytes)
{
 7cd:	55                   	push   %ebp
 7ce:	89 e5                	mov    %esp,%ebp
 7d0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d3:	8b 45 08             	mov    0x8(%ebp),%eax
 7d6:	83 c0 07             	add    $0x7,%eax
 7d9:	c1 e8 03             	shr    $0x3,%eax
 7dc:	83 c0 01             	add    $0x1,%eax
 7df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e2:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 7e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ee:	75 23                	jne    813 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f0:	c7 45 f0 64 0b 00 00 	movl   $0xb64,-0x10(%ebp)
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	a3 6c 0b 00 00       	mov    %eax,0xb6c
 7ff:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 804:	a3 64 0b 00 00       	mov    %eax,0xb64
    base.s.size = 0;
 809:	c7 05 68 0b 00 00 00 	movl   $0x0,0xb68
 810:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 813:	8b 45 f0             	mov    -0x10(%ebp),%eax
 816:	8b 00                	mov    (%eax),%eax
 818:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 40 04             	mov    0x4(%eax),%eax
 821:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 824:	72 4d                	jb     873 <malloc+0xa6>
      if(p->s.size == nunits)
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 40 04             	mov    0x4(%eax),%eax
 82c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82f:	75 0c                	jne    83d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 10                	mov    (%eax),%edx
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	89 10                	mov    %edx,(%eax)
 83b:	eb 26                	jmp    863 <malloc+0x96>
      else {
        p->s.size -= nunits;
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	8b 40 04             	mov    0x4(%eax),%eax
 843:	2b 45 ec             	sub    -0x14(%ebp),%eax
 846:	89 c2                	mov    %eax,%edx
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	c1 e0 03             	shl    $0x3,%eax
 857:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 860:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	a3 6c 0b 00 00       	mov    %eax,0xb6c
      return (void*)(p + 1);
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	83 c0 08             	add    $0x8,%eax
 871:	eb 3b                	jmp    8ae <malloc+0xe1>
    }
    if(p == freep)
 873:	a1 6c 0b 00 00       	mov    0xb6c,%eax
 878:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 87b:	75 1e                	jne    89b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 87d:	83 ec 0c             	sub    $0xc,%esp
 880:	ff 75 ec             	pushl  -0x14(%ebp)
 883:	e8 e5 fe ff ff       	call   76d <morecore>
 888:	83 c4 10             	add    $0x10,%esp
 88b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 892:	75 07                	jne    89b <malloc+0xce>
        return 0;
 894:	b8 00 00 00 00       	mov    $0x0,%eax
 899:	eb 13                	jmp    8ae <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a9:	e9 6d ff ff ff       	jmp    81b <malloc+0x4e>
}
 8ae:	c9                   	leave  
 8af:	c3                   	ret    
