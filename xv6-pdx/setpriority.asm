
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
  20:	e8 2a 02 00 00       	call   24f <atoi>
  25:	83 c4 10             	add    $0x10,%esp
  28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int priority = atoi(argv[2]);	
  2b:	8b 43 04             	mov    0x4(%ebx),%eax
  2e:	83 c0 08             	add    $0x8,%eax
  31:	8b 00                	mov    (%eax),%eax
  33:	83 ec 0c             	sub    $0xc,%esp
  36:	50                   	push   %eax
  37:	e8 13 02 00 00       	call   24f <atoi>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  //printf(1,"testing setting priority %d...%d\n", pid, priority);
  int rc = setpriority(pid, priority);
  42:	83 ec 08             	sub    $0x8,%esp
  45:	ff 75 f0             	pushl  -0x10(%ebp)
  48:	ff 75 f4             	pushl  -0xc(%ebp)
  4b:	e8 b6 03 00 00       	call   406 <setpriority>
  50:	83 c4 10             	add    $0x10,%esp
  53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(rc == -1){
  56:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  5a:	75 14                	jne    70 <main+0x70>
  	printf(1, "Invalid argument\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 9b 08 00 00       	push   $0x89b
  64:	6a 01                	push   $0x1
  66:	e8 7a 04 00 00       	call   4e5 <printf>
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	eb 15                	jmp    85 <main+0x85>
  }else{
  	printf(1,"The RC values is: %d\n", rc);	
  70:	83 ec 04             	sub    $0x4,%esp
  73:	ff 75 ec             	pushl  -0x14(%ebp)
  76:	68 ad 08 00 00       	push   $0x8ad
  7b:	6a 01                	push   $0x1
  7d:	e8 63 04 00 00       	call   4e5 <printf>
  82:	83 c4 10             	add    $0x10,%esp
  }	
  //printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  exit();
  85:	e8 9c 02 00 00       	call   326 <exit>

0000008a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	57                   	push   %edi
  8e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  92:	8b 55 10             	mov    0x10(%ebp),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	89 cb                	mov    %ecx,%ebx
  9a:	89 df                	mov    %ebx,%edi
  9c:	89 d1                	mov    %edx,%ecx
  9e:	fc                   	cld    
  9f:	f3 aa                	rep stos %al,%es:(%edi)
  a1:	89 ca                	mov    %ecx,%edx
  a3:	89 fb                	mov    %edi,%ebx
  a5:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  ab:	90                   	nop
  ac:	5b                   	pop    %ebx
  ad:	5f                   	pop    %edi
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  bc:	90                   	nop
  bd:	8b 45 08             	mov    0x8(%ebp),%eax
  c0:	8d 50 01             	lea    0x1(%eax),%edx
  c3:	89 55 08             	mov    %edx,0x8(%ebp)
  c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  cf:	0f b6 12             	movzbl (%edx),%edx
  d2:	88 10                	mov    %dl,(%eax)
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	84 c0                	test   %al,%al
  d9:	75 e2                	jne    bd <strcpy+0xd>
    ;
  return os;
  db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  de:	c9                   	leave  
  df:	c3                   	ret    

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e3:	eb 08                	jmp    ed <strcmp+0xd>
    p++, q++;
  e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	0f b6 00             	movzbl (%eax),%eax
  f3:	84 c0                	test   %al,%al
  f5:	74 10                	je     107 <strcmp+0x27>
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
  fa:	0f b6 10             	movzbl (%eax),%edx
  fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 100:	0f b6 00             	movzbl (%eax),%eax
 103:	38 c2                	cmp    %al,%dl
 105:	74 de                	je     e5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	0f b6 00             	movzbl (%eax),%eax
 10d:	0f b6 d0             	movzbl %al,%edx
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	0f b6 c0             	movzbl %al,%eax
 119:	29 c2                	sub    %eax,%edx
 11b:	89 d0                	mov    %edx,%eax
}
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <strlen>:

uint
strlen(char *s)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12c:	eb 04                	jmp    132 <strlen+0x13>
 12e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 132:	8b 55 fc             	mov    -0x4(%ebp),%edx
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	01 d0                	add    %edx,%eax
 13a:	0f b6 00             	movzbl (%eax),%eax
 13d:	84 c0                	test   %al,%al
 13f:	75 ed                	jne    12e <strlen+0xf>
    ;
  return n;
 141:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <memset>:

void*
memset(void *dst, int c, uint n)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 149:	8b 45 10             	mov    0x10(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	ff 75 0c             	pushl  0xc(%ebp)
 150:	ff 75 08             	pushl  0x8(%ebp)
 153:	e8 32 ff ff ff       	call   8a <stosb>
 158:	83 c4 0c             	add    $0xc,%esp
  return dst;
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15e:	c9                   	leave  
 15f:	c3                   	ret    

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 04             	sub    $0x4,%esp
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16c:	eb 14                	jmp    182 <strchr+0x22>
    if(*s == c)
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	3a 45 fc             	cmp    -0x4(%ebp),%al
 177:	75 05                	jne    17e <strchr+0x1e>
      return (char*)s;
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	eb 13                	jmp    191 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	75 e2                	jne    16e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 191:	c9                   	leave  
 192:	c3                   	ret    

00000193 <gets>:

char*
gets(char *buf, int max)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 199:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a0:	eb 42                	jmp    1e4 <gets+0x51>
    cc = read(0, &c, 1);
 1a2:	83 ec 04             	sub    $0x4,%esp
 1a5:	6a 01                	push   $0x1
 1a7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1aa:	50                   	push   %eax
 1ab:	6a 00                	push   $0x0
 1ad:	e8 8c 01 00 00       	call   33e <read>
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1bc:	7e 33                	jle    1f1 <gets+0x5e>
      break;
    buf[i++] = c;
 1be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c1:	8d 50 01             	lea    0x1(%eax),%edx
 1c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c7:	89 c2                	mov    %eax,%edx
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	01 c2                	add    %eax,%edx
 1ce:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	3c 0a                	cmp    $0xa,%al
 1da:	74 16                	je     1f2 <gets+0x5f>
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 0e                	je     1f2 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ed:	7c b3                	jl     1a2 <gets+0xf>
 1ef:	eb 01                	jmp    1f2 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	01 d0                	add    %edx,%eax
 1fa:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <stat>:

int
stat(char *n, struct stat *st)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 208:	83 ec 08             	sub    $0x8,%esp
 20b:	6a 00                	push   $0x0
 20d:	ff 75 08             	pushl  0x8(%ebp)
 210:	e8 51 01 00 00       	call   366 <open>
 215:	83 c4 10             	add    $0x10,%esp
 218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21f:	79 07                	jns    228 <stat+0x26>
    return -1;
 221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 226:	eb 25                	jmp    24d <stat+0x4b>
  r = fstat(fd, st);
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	ff 75 0c             	pushl  0xc(%ebp)
 22e:	ff 75 f4             	pushl  -0xc(%ebp)
 231:	e8 48 01 00 00       	call   37e <fstat>
 236:	83 c4 10             	add    $0x10,%esp
 239:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23c:	83 ec 0c             	sub    $0xc,%esp
 23f:	ff 75 f4             	pushl  -0xc(%ebp)
 242:	e8 07 01 00 00       	call   34e <close>
 247:	83 c4 10             	add    $0x10,%esp
  return r;
 24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24d:	c9                   	leave  
 24e:	c3                   	ret    

0000024f <atoi>:

int
atoi(const char *s)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 25c:	eb 04                	jmp    262 <atoi+0x13>
 25e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	3c 20                	cmp    $0x20,%al
 26a:	74 f2                	je     25e <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	3c 2d                	cmp    $0x2d,%al
 274:	75 07                	jne    27d <atoi+0x2e>
 276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27b:	eb 05                	jmp    282 <atoi+0x33>
 27d:	b8 01 00 00 00       	mov    $0x1,%eax
 282:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	3c 2b                	cmp    $0x2b,%al
 28d:	74 0a                	je     299 <atoi+0x4a>
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	3c 2d                	cmp    $0x2d,%al
 297:	75 2b                	jne    2c4 <atoi+0x75>
    s++;
 299:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 29d:	eb 25                	jmp    2c4 <atoi+0x75>
    n = n*10 + *s++ - '0';
 29f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a2:	89 d0                	mov    %edx,%eax
 2a4:	c1 e0 02             	shl    $0x2,%eax
 2a7:	01 d0                	add    %edx,%eax
 2a9:	01 c0                	add    %eax,%eax
 2ab:	89 c1                	mov    %eax,%ecx
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	8d 50 01             	lea    0x1(%eax),%edx
 2b3:	89 55 08             	mov    %edx,0x8(%ebp)
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	0f be c0             	movsbl %al,%eax
 2bc:	01 c8                	add    %ecx,%eax
 2be:	83 e8 30             	sub    $0x30,%eax
 2c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	3c 2f                	cmp    $0x2f,%al
 2cc:	7e 0a                	jle    2d8 <atoi+0x89>
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	3c 39                	cmp    $0x39,%al
 2d6:	7e c7                	jle    29f <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2db:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2df:	c9                   	leave  
 2e0:	c3                   	ret    

000002e1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e1:	55                   	push   %ebp
 2e2:	89 e5                	mov    %esp,%ebp
 2e4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f3:	eb 17                	jmp    30c <memmove+0x2b>
    *dst++ = *src++;
 2f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f8:	8d 50 01             	lea    0x1(%eax),%edx
 2fb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 301:	8d 4a 01             	lea    0x1(%edx),%ecx
 304:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 307:	0f b6 12             	movzbl (%edx),%edx
 30a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30c:	8b 45 10             	mov    0x10(%ebp),%eax
 30f:	8d 50 ff             	lea    -0x1(%eax),%edx
 312:	89 55 10             	mov    %edx,0x10(%ebp)
 315:	85 c0                	test   %eax,%eax
 317:	7f dc                	jg     2f5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31e:	b8 01 00 00 00       	mov    $0x1,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <exit>:
SYSCALL(exit)
 326:	b8 02 00 00 00       	mov    $0x2,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <wait>:
SYSCALL(wait)
 32e:	b8 03 00 00 00       	mov    $0x3,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <pipe>:
SYSCALL(pipe)
 336:	b8 04 00 00 00       	mov    $0x4,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <read>:
SYSCALL(read)
 33e:	b8 05 00 00 00       	mov    $0x5,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <write>:
SYSCALL(write)
 346:	b8 10 00 00 00       	mov    $0x10,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <close>:
SYSCALL(close)
 34e:	b8 15 00 00 00       	mov    $0x15,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <kill>:
SYSCALL(kill)
 356:	b8 06 00 00 00       	mov    $0x6,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <exec>:
SYSCALL(exec)
 35e:	b8 07 00 00 00       	mov    $0x7,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <open>:
SYSCALL(open)
 366:	b8 0f 00 00 00       	mov    $0xf,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <mknod>:
SYSCALL(mknod)
 36e:	b8 11 00 00 00       	mov    $0x11,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <unlink>:
SYSCALL(unlink)
 376:	b8 12 00 00 00       	mov    $0x12,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <fstat>:
SYSCALL(fstat)
 37e:	b8 08 00 00 00       	mov    $0x8,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <link>:
SYSCALL(link)
 386:	b8 13 00 00 00       	mov    $0x13,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <mkdir>:
SYSCALL(mkdir)
 38e:	b8 14 00 00 00       	mov    $0x14,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <chdir>:
SYSCALL(chdir)
 396:	b8 09 00 00 00       	mov    $0x9,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <dup>:
SYSCALL(dup)
 39e:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <getpid>:
SYSCALL(getpid)
 3a6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <sbrk>:
SYSCALL(sbrk)
 3ae:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <sleep>:
SYSCALL(sleep)
 3b6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <uptime>:
SYSCALL(uptime)
 3be:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <halt>:
SYSCALL(halt)
 3c6:	b8 16 00 00 00       	mov    $0x16,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <date>:
SYSCALL(date)
 3ce:	b8 17 00 00 00       	mov    $0x17,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <getuid>:
SYSCALL(getuid)
 3d6:	b8 18 00 00 00       	mov    $0x18,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <getgid>:
SYSCALL(getgid)
 3de:	b8 19 00 00 00       	mov    $0x19,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getppid>:
SYSCALL(getppid)
 3e6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <setuid>:
SYSCALL(setuid)
 3ee:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <setgid>:
SYSCALL(setgid)
 3f6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <getprocs>:
SYSCALL(getprocs)
 3fe:	b8 1d 00 00 00       	mov    $0x1d,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <setpriority>:
SYSCALL(setpriority)
 406:	b8 1e 00 00 00       	mov    $0x1e,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 18             	sub    $0x18,%esp
 414:	8b 45 0c             	mov    0xc(%ebp),%eax
 417:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 41a:	83 ec 04             	sub    $0x4,%esp
 41d:	6a 01                	push   $0x1
 41f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 422:	50                   	push   %eax
 423:	ff 75 08             	pushl  0x8(%ebp)
 426:	e8 1b ff ff ff       	call   346 <write>
 42b:	83 c4 10             	add    $0x10,%esp
}
 42e:	90                   	nop
 42f:	c9                   	leave  
 430:	c3                   	ret    

00000431 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	53                   	push   %ebx
 435:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 438:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 443:	74 17                	je     45c <printint+0x2b>
 445:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 449:	79 11                	jns    45c <printint+0x2b>
    neg = 1;
 44b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	f7 d8                	neg    %eax
 457:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45a:	eb 06                	jmp    462 <printint+0x31>
  } else {
    x = xx;
 45c:	8b 45 0c             	mov    0xc(%ebp),%eax
 45f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 469:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 46c:	8d 41 01             	lea    0x1(%ecx),%eax
 46f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 472:	8b 5d 10             	mov    0x10(%ebp),%ebx
 475:	8b 45 ec             	mov    -0x14(%ebp),%eax
 478:	ba 00 00 00 00       	mov    $0x0,%edx
 47d:	f7 f3                	div    %ebx
 47f:	89 d0                	mov    %edx,%eax
 481:	0f b6 80 18 0b 00 00 	movzbl 0xb18(%eax),%eax
 488:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 48c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 492:	ba 00 00 00 00       	mov    $0x0,%edx
 497:	f7 f3                	div    %ebx
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a0:	75 c7                	jne    469 <printint+0x38>
  if(neg)
 4a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a6:	74 2d                	je     4d5 <printint+0xa4>
    buf[i++] = '-';
 4a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ab:	8d 50 01             	lea    0x1(%eax),%edx
 4ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b6:	eb 1d                	jmp    4d5 <printint+0xa4>
    putc(fd, buf[i]);
 4b8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4be:	01 d0                	add    %edx,%eax
 4c0:	0f b6 00             	movzbl (%eax),%eax
 4c3:	0f be c0             	movsbl %al,%eax
 4c6:	83 ec 08             	sub    $0x8,%esp
 4c9:	50                   	push   %eax
 4ca:	ff 75 08             	pushl  0x8(%ebp)
 4cd:	e8 3c ff ff ff       	call   40e <putc>
 4d2:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4dd:	79 d9                	jns    4b8 <printint+0x87>
    putc(fd, buf[i]);
}
 4df:	90                   	nop
 4e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e3:	c9                   	leave  
 4e4:	c3                   	ret    

000004e5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e5:	55                   	push   %ebp
 4e6:	89 e5                	mov    %esp,%ebp
 4e8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f5:	83 c0 04             	add    $0x4,%eax
 4f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 502:	e9 59 01 00 00       	jmp    660 <printf+0x17b>
    c = fmt[i] & 0xff;
 507:	8b 55 0c             	mov    0xc(%ebp),%edx
 50a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50d:	01 d0                	add    %edx,%eax
 50f:	0f b6 00             	movzbl (%eax),%eax
 512:	0f be c0             	movsbl %al,%eax
 515:	25 ff 00 00 00       	and    $0xff,%eax
 51a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 521:	75 2c                	jne    54f <printf+0x6a>
      if(c == '%'){
 523:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 527:	75 0c                	jne    535 <printf+0x50>
        state = '%';
 529:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 530:	e9 27 01 00 00       	jmp    65c <printf+0x177>
      } else {
        putc(fd, c);
 535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	83 ec 08             	sub    $0x8,%esp
 53e:	50                   	push   %eax
 53f:	ff 75 08             	pushl  0x8(%ebp)
 542:	e8 c7 fe ff ff       	call   40e <putc>
 547:	83 c4 10             	add    $0x10,%esp
 54a:	e9 0d 01 00 00       	jmp    65c <printf+0x177>
      }
    } else if(state == '%'){
 54f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 553:	0f 85 03 01 00 00    	jne    65c <printf+0x177>
      if(c == 'd'){
 559:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55d:	75 1e                	jne    57d <printf+0x98>
        printint(fd, *ap, 10, 1);
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	8b 00                	mov    (%eax),%eax
 564:	6a 01                	push   $0x1
 566:	6a 0a                	push   $0xa
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 c0 fe ff ff       	call   431 <printint>
 571:	83 c4 10             	add    $0x10,%esp
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 578:	e9 d8 00 00 00       	jmp    655 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 57d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 581:	74 06                	je     589 <printf+0xa4>
 583:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 587:	75 1e                	jne    5a7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	8b 00                	mov    (%eax),%eax
 58e:	6a 00                	push   $0x0
 590:	6a 10                	push   $0x10
 592:	50                   	push   %eax
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 96 fe ff ff       	call   431 <printint>
 59b:	83 c4 10             	add    $0x10,%esp
        ap++;
 59e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a2:	e9 ae 00 00 00       	jmp    655 <printf+0x170>
      } else if(c == 's'){
 5a7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ab:	75 43                	jne    5f0 <printf+0x10b>
        s = (char*)*ap;
 5ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b0:	8b 00                	mov    (%eax),%eax
 5b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bd:	75 25                	jne    5e4 <printf+0xff>
          s = "(null)";
 5bf:	c7 45 f4 c3 08 00 00 	movl   $0x8c3,-0xc(%ebp)
        while(*s != 0){
 5c6:	eb 1c                	jmp    5e4 <printf+0xff>
          putc(fd, *s);
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	83 ec 08             	sub    $0x8,%esp
 5d4:	50                   	push   %eax
 5d5:	ff 75 08             	pushl  0x8(%ebp)
 5d8:	e8 31 fe ff ff       	call   40e <putc>
 5dd:	83 c4 10             	add    $0x10,%esp
          s++;
 5e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	84 c0                	test   %al,%al
 5ec:	75 da                	jne    5c8 <printf+0xe3>
 5ee:	eb 65                	jmp    655 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f4:	75 1d                	jne    613 <printf+0x12e>
        putc(fd, *ap);
 5f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	0f be c0             	movsbl %al,%eax
 5fe:	83 ec 08             	sub    $0x8,%esp
 601:	50                   	push   %eax
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	e8 04 fe ff ff       	call   40e <putc>
 60a:	83 c4 10             	add    $0x10,%esp
        ap++;
 60d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 611:	eb 42                	jmp    655 <printf+0x170>
      } else if(c == '%'){
 613:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 617:	75 17                	jne    630 <printf+0x14b>
        putc(fd, c);
 619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	50                   	push   %eax
 623:	ff 75 08             	pushl  0x8(%ebp)
 626:	e8 e3 fd ff ff       	call   40e <putc>
 62b:	83 c4 10             	add    $0x10,%esp
 62e:	eb 25                	jmp    655 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 630:	83 ec 08             	sub    $0x8,%esp
 633:	6a 25                	push   $0x25
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 d1 fd ff ff       	call   40e <putc>
 63d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 643:	0f be c0             	movsbl %al,%eax
 646:	83 ec 08             	sub    $0x8,%esp
 649:	50                   	push   %eax
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 bc fd ff ff       	call   40e <putc>
 652:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 655:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 660:	8b 55 0c             	mov    0xc(%ebp),%edx
 663:	8b 45 f0             	mov    -0x10(%ebp),%eax
 666:	01 d0                	add    %edx,%eax
 668:	0f b6 00             	movzbl (%eax),%eax
 66b:	84 c0                	test   %al,%al
 66d:	0f 85 94 fe ff ff    	jne    507 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 673:	90                   	nop
 674:	c9                   	leave  
 675:	c3                   	ret    

00000676 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	55                   	push   %ebp
 677:	89 e5                	mov    %esp,%ebp
 679:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	83 e8 08             	sub    $0x8,%eax
 682:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 685:	a1 34 0b 00 00       	mov    0xb34,%eax
 68a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68d:	eb 24                	jmp    6b3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 697:	77 12                	ja     6ab <free+0x35>
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69f:	77 24                	ja     6c5 <free+0x4f>
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a9:	77 1a                	ja     6c5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b9:	76 d4                	jbe    68f <free+0x19>
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c3:	76 ca                	jbe    68f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 40 04             	mov    0x4(%eax),%eax
 6cb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	39 c2                	cmp    %eax,%edx
 6de:	75 24                	jne    704 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 50 04             	mov    0x4(%eax),%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	8b 40 04             	mov    0x4(%eax),%eax
 6ee:	01 c2                	add    %eax,%edx
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	8b 10                	mov    (%eax),%edx
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	89 10                	mov    %edx,(%eax)
 702:	eb 0a                	jmp    70e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 10                	mov    (%eax),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	01 d0                	add    %edx,%eax
 720:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 723:	75 20                	jne    745 <free+0xcf>
    p->s.size += bp->s.size;
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 50 04             	mov    0x4(%eax),%edx
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	01 c2                	add    %eax,%edx
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	8b 10                	mov    (%eax),%edx
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	89 10                	mov    %edx,(%eax)
 743:	eb 08                	jmp    74d <free+0xd7>
  } else
    p->s.ptr = bp;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74b:	89 10                	mov    %edx,(%eax)
  freep = p;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	a3 34 0b 00 00       	mov    %eax,0xb34
}
 755:	90                   	nop
 756:	c9                   	leave  
 757:	c3                   	ret    

00000758 <morecore>:

static Header*
morecore(uint nu)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 765:	77 07                	ja     76e <morecore+0x16>
    nu = 4096;
 767:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	c1 e0 03             	shl    $0x3,%eax
 774:	83 ec 0c             	sub    $0xc,%esp
 777:	50                   	push   %eax
 778:	e8 31 fc ff ff       	call   3ae <sbrk>
 77d:	83 c4 10             	add    $0x10,%esp
 780:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 783:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 787:	75 07                	jne    790 <morecore+0x38>
    return 0;
 789:	b8 00 00 00 00       	mov    $0x0,%eax
 78e:	eb 26                	jmp    7b6 <morecore+0x5e>
  hp = (Header*)p;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	8b 55 08             	mov    0x8(%ebp),%edx
 79c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	83 c0 08             	add    $0x8,%eax
 7a5:	83 ec 0c             	sub    $0xc,%esp
 7a8:	50                   	push   %eax
 7a9:	e8 c8 fe ff ff       	call   676 <free>
 7ae:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b1:	a1 34 0b 00 00       	mov    0xb34,%eax
}
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <malloc>:

void*
malloc(uint nbytes)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	83 c0 07             	add    $0x7,%eax
 7c4:	c1 e8 03             	shr    $0x3,%eax
 7c7:	83 c0 01             	add    $0x1,%eax
 7ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7cd:	a1 34 0b 00 00       	mov    0xb34,%eax
 7d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d9:	75 23                	jne    7fe <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7db:	c7 45 f0 2c 0b 00 00 	movl   $0xb2c,-0x10(%ebp)
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	a3 34 0b 00 00       	mov    %eax,0xb34
 7ea:	a1 34 0b 00 00       	mov    0xb34,%eax
 7ef:	a3 2c 0b 00 00       	mov    %eax,0xb2c
    base.s.size = 0;
 7f4:	c7 05 30 0b 00 00 00 	movl   $0x0,0xb30
 7fb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80f:	72 4d                	jb     85e <malloc+0xa6>
      if(p->s.size == nunits)
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81a:	75 0c                	jne    828 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 10                	mov    (%eax),%edx
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	89 10                	mov    %edx,(%eax)
 826:	eb 26                	jmp    84e <malloc+0x96>
      else {
        p->s.size -= nunits;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 831:	89 c2                	mov    %eax,%edx
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	c1 e0 03             	shl    $0x3,%eax
 842:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 55 ec             	mov    -0x14(%ebp),%edx
 84b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 84e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 851:	a3 34 0b 00 00       	mov    %eax,0xb34
      return (void*)(p + 1);
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	83 c0 08             	add    $0x8,%eax
 85c:	eb 3b                	jmp    899 <malloc+0xe1>
    }
    if(p == freep)
 85e:	a1 34 0b 00 00       	mov    0xb34,%eax
 863:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 866:	75 1e                	jne    886 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 868:	83 ec 0c             	sub    $0xc,%esp
 86b:	ff 75 ec             	pushl  -0x14(%ebp)
 86e:	e8 e5 fe ff ff       	call   758 <morecore>
 873:	83 c4 10             	add    $0x10,%esp
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
 879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87d:	75 07                	jne    886 <malloc+0xce>
        return 0;
 87f:	b8 00 00 00 00       	mov    $0x0,%eax
 884:	eb 13                	jmp    899 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 894:	e9 6d ff ff ff       	jmp    806 <malloc+0x4e>
}
 899:	c9                   	leave  
 89a:	c3                   	ret    
