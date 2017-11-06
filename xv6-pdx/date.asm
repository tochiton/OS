
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <dayofweek>:
  "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
static char *days[] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

int
dayofweek(int y, int m, int d)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
   4:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
   8:	7f 0b                	jg     15 <dayofweek+0x15>
   a:	8b 45 08             	mov    0x8(%ebp),%eax
   d:	8d 50 ff             	lea    -0x1(%eax),%edx
  10:	89 55 08             	mov    %edx,0x8(%ebp)
  13:	eb 06                	jmp    1b <dayofweek+0x1b>
  15:	8b 45 08             	mov    0x8(%ebp),%eax
  18:	83 e8 02             	sub    $0x2,%eax
  1b:	01 45 10             	add    %eax,0x10(%ebp)
  1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  21:	6b c8 17             	imul   $0x17,%eax,%ecx
  24:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	f7 ea                	imul   %edx
  2d:	d1 fa                	sar    %edx
  2f:	89 c8                	mov    %ecx,%eax
  31:	c1 f8 1f             	sar    $0x1f,%eax
  34:	29 c2                	sub    %eax,%edx
  36:	8b 45 10             	mov    0x10(%ebp),%eax
  39:	01 d0                	add    %edx,%eax
  3b:	8d 48 04             	lea    0x4(%eax),%ecx
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 03             	lea    0x3(%eax),%edx
  44:	85 c0                	test   %eax,%eax
  46:	0f 48 c2             	cmovs  %edx,%eax
  49:	c1 f8 02             	sar    $0x2,%eax
  4c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  57:	89 c8                	mov    %ecx,%eax
  59:	f7 ea                	imul   %edx
  5b:	c1 fa 05             	sar    $0x5,%edx
  5e:	89 c8                	mov    %ecx,%eax
  60:	c1 f8 1f             	sar    $0x1f,%eax
  63:	29 c2                	sub    %eax,%edx
  65:	89 d0                	mov    %edx,%eax
  67:	29 c3                	sub    %eax,%ebx
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  71:	89 c8                	mov    %ecx,%eax
  73:	f7 ea                	imul   %edx
  75:	c1 fa 07             	sar    $0x7,%edx
  78:	89 c8                	mov    %ecx,%eax
  7a:	c1 f8 1f             	sar    $0x1f,%eax
  7d:	29 c2                	sub    %eax,%edx
  7f:	89 d0                	mov    %edx,%eax
  81:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  84:	ba 93 24 49 92       	mov    $0x92492493,%edx
  89:	89 c8                	mov    %ecx,%eax
  8b:	f7 ea                	imul   %edx
  8d:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  90:	c1 f8 02             	sar    $0x2,%eax
  93:	89 c2                	mov    %eax,%edx
  95:	89 c8                	mov    %ecx,%eax
  97:	c1 f8 1f             	sar    $0x1f,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	c1 e2 03             	shl    $0x3,%edx
  a3:	29 c2                	sub    %eax,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5b                   	pop    %ebx
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  b0:	83 e4 f0             	and    $0xfffffff0,%esp
  b3:	ff 71 fc             	pushl  -0x4(%ecx)
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	53                   	push   %ebx
  ba:	51                   	push   %ecx
  bb:	83 ec 20             	sub    $0x20,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  be:	83 ec 0c             	sub    $0xc,%esp
  c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  c4:	50                   	push   %eax
  c5:	e8 d7 03 00 00       	call   4a1 <date>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	85 c0                	test   %eax,%eax
  cf:	74 1b                	je     ec <main+0x40>
    printf(2,"Error: date call failed. %s at line %d\n", __FILE__, __LINE__);
  d1:	6a 1a                	push   $0x1a
  d3:	68 c1 09 00 00       	push   $0x9c1
  d8:	68 c8 09 00 00       	push   $0x9c8
  dd:	6a 02                	push   $0x2
  df:	e8 d4 04 00 00       	call   5b8 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
    exit();
  e7:	e8 0d 03 00 00       	call   3f9 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ef:	89 c1                	mov    %eax,%ecx
  f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  f4:	89 c2                	mov    %eax,%edx
  f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f9:	83 ec 04             	sub    $0x4,%esp
  fc:	51                   	push   %ecx
  fd:	52                   	push   %edx
  fe:	50                   	push   %eax
  ff:	e8 fc fe ff ff       	call   0 <dayofweek>
 104:	83 c4 10             	add    $0x10,%esp
 107:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "%s %s %d", days[day], months[r.month], r.day);
 10a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 10d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 110:	8b 14 85 a0 0c 00 00 	mov    0xca0(,%eax,4),%edx
 117:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11a:	8b 04 85 d4 0c 00 00 	mov    0xcd4(,%eax,4),%eax
 121:	83 ec 0c             	sub    $0xc,%esp
 124:	51                   	push   %ecx
 125:	52                   	push   %edx
 126:	50                   	push   %eax
 127:	68 f0 09 00 00       	push   $0x9f0
 12c:	6a 01                	push   $0x1
 12e:	e8 85 04 00 00       	call   5b8 <printf>
 133:	83 c4 20             	add    $0x20,%esp
  printf(1, " %d:%d:%d UTC %d\n", r.hour, r.minute, r.second, r.year);
 136:	8b 5d f0             	mov    -0x10(%ebp),%ebx
 139:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 13c:	8b 55 e0             	mov    -0x20(%ebp),%edx
 13f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 142:	83 ec 08             	sub    $0x8,%esp
 145:	53                   	push   %ebx
 146:	51                   	push   %ecx
 147:	52                   	push   %edx
 148:	50                   	push   %eax
 149:	68 f9 09 00 00       	push   $0x9f9
 14e:	6a 01                	push   $0x1
 150:	e8 63 04 00 00       	call   5b8 <printf>
 155:	83 c4 20             	add    $0x20,%esp

  exit();
 158:	e8 9c 02 00 00       	call   3f9 <exit>

0000015d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 162:	8b 4d 08             	mov    0x8(%ebp),%ecx
 165:	8b 55 10             	mov    0x10(%ebp),%edx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	89 cb                	mov    %ecx,%ebx
 16d:	89 df                	mov    %ebx,%edi
 16f:	89 d1                	mov    %edx,%ecx
 171:	fc                   	cld    
 172:	f3 aa                	rep stos %al,%es:(%edi)
 174:	89 ca                	mov    %ecx,%edx
 176:	89 fb                	mov    %edi,%ebx
 178:	89 5d 08             	mov    %ebx,0x8(%ebp)
 17b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 17e:	90                   	nop
 17f:	5b                   	pop    %ebx
 180:	5f                   	pop    %edi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    

00000183 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 18f:	90                   	nop
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	8d 50 01             	lea    0x1(%eax),%edx
 196:	89 55 08             	mov    %edx,0x8(%ebp)
 199:	8b 55 0c             	mov    0xc(%ebp),%edx
 19c:	8d 4a 01             	lea    0x1(%edx),%ecx
 19f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a2:	0f b6 12             	movzbl (%edx),%edx
 1a5:	88 10                	mov    %dl,(%eax)
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	84 c0                	test   %al,%al
 1ac:	75 e2                	jne    190 <strcpy+0xd>
    ;
  return os;
 1ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b6:	eb 08                	jmp    1c0 <strcmp+0xd>
    p++, q++;
 1b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	84 c0                	test   %al,%al
 1c8:	74 10                	je     1da <strcmp+0x27>
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	0f b6 10             	movzbl (%eax),%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	38 c2                	cmp    %al,%dl
 1d8:	74 de                	je     1b8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	0f b6 00             	movzbl (%eax),%eax
 1e0:	0f b6 d0             	movzbl %al,%edx
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	0f b6 00             	movzbl (%eax),%eax
 1e9:	0f b6 c0             	movzbl %al,%eax
 1ec:	29 c2                	sub    %eax,%edx
 1ee:	89 d0                	mov    %edx,%eax
}
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    

000001f2 <strlen>:

uint
strlen(char *s)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ff:	eb 04                	jmp    205 <strlen+0x13>
 201:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	84 c0                	test   %al,%al
 212:	75 ed                	jne    201 <strlen+0xf>
    ;
  return n;
 214:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <memset>:

void*
memset(void *dst, int c, uint n)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 21c:	8b 45 10             	mov    0x10(%ebp),%eax
 21f:	50                   	push   %eax
 220:	ff 75 0c             	pushl  0xc(%ebp)
 223:	ff 75 08             	pushl  0x8(%ebp)
 226:	e8 32 ff ff ff       	call   15d <stosb>
 22b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <strchr>:

char*
strchr(const char *s, char c)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 04             	sub    $0x4,%esp
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23f:	eb 14                	jmp    255 <strchr+0x22>
    if(*s == c)
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24a:	75 05                	jne    251 <strchr+0x1e>
      return (char*)s;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	eb 13                	jmp    264 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 251:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	84 c0                	test   %al,%al
 25d:	75 e2                	jne    241 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <gets>:

char*
gets(char *buf, int max)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 273:	eb 42                	jmp    2b7 <gets+0x51>
    cc = read(0, &c, 1);
 275:	83 ec 04             	sub    $0x4,%esp
 278:	6a 01                	push   $0x1
 27a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 27d:	50                   	push   %eax
 27e:	6a 00                	push   $0x0
 280:	e8 8c 01 00 00       	call   411 <read>
 285:	83 c4 10             	add    $0x10,%esp
 288:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28f:	7e 33                	jle    2c4 <gets+0x5e>
      break;
    buf[i++] = c;
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	01 c2                	add    %eax,%edx
 2a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ab:	3c 0a                	cmp    $0xa,%al
 2ad:	74 16                	je     2c5 <gets+0x5f>
 2af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 0e                	je     2c5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ba:	83 c0 01             	add    $0x1,%eax
 2bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c0:	7c b3                	jl     275 <gets+0xf>
 2c2:	eb 01                	jmp    2c5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	01 d0                	add    %edx,%eax
 2cd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <stat>:

int
stat(char *n, struct stat *st)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2db:	83 ec 08             	sub    $0x8,%esp
 2de:	6a 00                	push   $0x0
 2e0:	ff 75 08             	pushl  0x8(%ebp)
 2e3:	e8 51 01 00 00       	call   439 <open>
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f2:	79 07                	jns    2fb <stat+0x26>
    return -1;
 2f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f9:	eb 25                	jmp    320 <stat+0x4b>
  r = fstat(fd, st);
 2fb:	83 ec 08             	sub    $0x8,%esp
 2fe:	ff 75 0c             	pushl  0xc(%ebp)
 301:	ff 75 f4             	pushl  -0xc(%ebp)
 304:	e8 48 01 00 00       	call   451 <fstat>
 309:	83 c4 10             	add    $0x10,%esp
 30c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30f:	83 ec 0c             	sub    $0xc,%esp
 312:	ff 75 f4             	pushl  -0xc(%ebp)
 315:	e8 07 01 00 00       	call   421 <close>
 31a:	83 c4 10             	add    $0x10,%esp
  return r;
 31d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <atoi>:

int
atoi(const char *s)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 32f:	eb 04                	jmp    335 <atoi+0x13>
 331:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	3c 20                	cmp    $0x20,%al
 33d:	74 f2                	je     331 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	0f b6 00             	movzbl (%eax),%eax
 345:	3c 2d                	cmp    $0x2d,%al
 347:	75 07                	jne    350 <atoi+0x2e>
 349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 34e:	eb 05                	jmp    355 <atoi+0x33>
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	3c 2b                	cmp    $0x2b,%al
 360:	74 0a                	je     36c <atoi+0x4a>
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	0f b6 00             	movzbl (%eax),%eax
 368:	3c 2d                	cmp    $0x2d,%al
 36a:	75 2b                	jne    397 <atoi+0x75>
    s++;
 36c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 370:	eb 25                	jmp    397 <atoi+0x75>
    n = n*10 + *s++ - '0';
 372:	8b 55 fc             	mov    -0x4(%ebp),%edx
 375:	89 d0                	mov    %edx,%eax
 377:	c1 e0 02             	shl    $0x2,%eax
 37a:	01 d0                	add    %edx,%eax
 37c:	01 c0                	add    %eax,%eax
 37e:	89 c1                	mov    %eax,%ecx
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	8d 50 01             	lea    0x1(%eax),%edx
 386:	89 55 08             	mov    %edx,0x8(%ebp)
 389:	0f b6 00             	movzbl (%eax),%eax
 38c:	0f be c0             	movsbl %al,%eax
 38f:	01 c8                	add    %ecx,%eax
 391:	83 e8 30             	sub    $0x30,%eax
 394:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	0f b6 00             	movzbl (%eax),%eax
 39d:	3c 2f                	cmp    $0x2f,%al
 39f:	7e 0a                	jle    3ab <atoi+0x89>
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	3c 39                	cmp    $0x39,%al
 3a9:	7e c7                	jle    372 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ae:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c6:	eb 17                	jmp    3df <memmove+0x2b>
    *dst++ = *src++;
 3c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3cb:	8d 50 01             	lea    0x1(%eax),%edx
 3ce:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3d1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d4:	8d 4a 01             	lea    0x1(%edx),%ecx
 3d7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3da:	0f b6 12             	movzbl (%edx),%edx
 3dd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3df:	8b 45 10             	mov    0x10(%ebp),%eax
 3e2:	8d 50 ff             	lea    -0x1(%eax),%edx
 3e5:	89 55 10             	mov    %edx,0x10(%ebp)
 3e8:	85 c0                	test   %eax,%eax
 3ea:	7f dc                	jg     3c8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ef:	c9                   	leave  
 3f0:	c3                   	ret    

000003f1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f1:	b8 01 00 00 00       	mov    $0x1,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <exit>:
SYSCALL(exit)
 3f9:	b8 02 00 00 00       	mov    $0x2,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <wait>:
SYSCALL(wait)
 401:	b8 03 00 00 00       	mov    $0x3,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <pipe>:
SYSCALL(pipe)
 409:	b8 04 00 00 00       	mov    $0x4,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <read>:
SYSCALL(read)
 411:	b8 05 00 00 00       	mov    $0x5,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <write>:
SYSCALL(write)
 419:	b8 10 00 00 00       	mov    $0x10,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <close>:
SYSCALL(close)
 421:	b8 15 00 00 00       	mov    $0x15,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <kill>:
SYSCALL(kill)
 429:	b8 06 00 00 00       	mov    $0x6,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <exec>:
SYSCALL(exec)
 431:	b8 07 00 00 00       	mov    $0x7,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <open>:
SYSCALL(open)
 439:	b8 0f 00 00 00       	mov    $0xf,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <mknod>:
SYSCALL(mknod)
 441:	b8 11 00 00 00       	mov    $0x11,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <unlink>:
SYSCALL(unlink)
 449:	b8 12 00 00 00       	mov    $0x12,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <fstat>:
SYSCALL(fstat)
 451:	b8 08 00 00 00       	mov    $0x8,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <link>:
SYSCALL(link)
 459:	b8 13 00 00 00       	mov    $0x13,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <mkdir>:
SYSCALL(mkdir)
 461:	b8 14 00 00 00       	mov    $0x14,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <chdir>:
SYSCALL(chdir)
 469:	b8 09 00 00 00       	mov    $0x9,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <dup>:
SYSCALL(dup)
 471:	b8 0a 00 00 00       	mov    $0xa,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <getpid>:
SYSCALL(getpid)
 479:	b8 0b 00 00 00       	mov    $0xb,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <sbrk>:
SYSCALL(sbrk)
 481:	b8 0c 00 00 00       	mov    $0xc,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <sleep>:
SYSCALL(sleep)
 489:	b8 0d 00 00 00       	mov    $0xd,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <uptime>:
SYSCALL(uptime)
 491:	b8 0e 00 00 00       	mov    $0xe,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <halt>:
SYSCALL(halt)
 499:	b8 16 00 00 00       	mov    $0x16,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <date>:
SYSCALL(date)
 4a1:	b8 17 00 00 00       	mov    $0x17,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <getuid>:
SYSCALL(getuid)
 4a9:	b8 18 00 00 00       	mov    $0x18,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <getgid>:
SYSCALL(getgid)
 4b1:	b8 19 00 00 00       	mov    $0x19,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <getppid>:
SYSCALL(getppid)
 4b9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <setuid>:
SYSCALL(setuid)
 4c1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <setgid>:
SYSCALL(setgid)
 4c9:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <getprocs>:
SYSCALL(getprocs)
 4d1:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <setpriority>:
SYSCALL(setpriority)
 4d9:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e1:	55                   	push   %ebp
 4e2:	89 e5                	mov    %esp,%ebp
 4e4:	83 ec 18             	sub    $0x18,%esp
 4e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ea:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ed:	83 ec 04             	sub    $0x4,%esp
 4f0:	6a 01                	push   $0x1
 4f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4f5:	50                   	push   %eax
 4f6:	ff 75 08             	pushl  0x8(%ebp)
 4f9:	e8 1b ff ff ff       	call   419 <write>
 4fe:	83 c4 10             	add    $0x10,%esp
}
 501:	90                   	nop
 502:	c9                   	leave  
 503:	c3                   	ret    

00000504 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 504:	55                   	push   %ebp
 505:	89 e5                	mov    %esp,%ebp
 507:	53                   	push   %ebx
 508:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 50b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 512:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 516:	74 17                	je     52f <printint+0x2b>
 518:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 51c:	79 11                	jns    52f <printint+0x2b>
    neg = 1;
 51e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 525:	8b 45 0c             	mov    0xc(%ebp),%eax
 528:	f7 d8                	neg    %eax
 52a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52d:	eb 06                	jmp    535 <printint+0x31>
  } else {
    x = xx;
 52f:	8b 45 0c             	mov    0xc(%ebp),%eax
 532:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 535:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 53c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 53f:	8d 41 01             	lea    0x1(%ecx),%eax
 542:	89 45 f4             	mov    %eax,-0xc(%ebp)
 545:	8b 5d 10             	mov    0x10(%ebp),%ebx
 548:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54b:	ba 00 00 00 00       	mov    $0x0,%edx
 550:	f7 f3                	div    %ebx
 552:	89 d0                	mov    %edx,%eax
 554:	0f b6 80 f0 0c 00 00 	movzbl 0xcf0(%eax),%eax
 55b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 55f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 562:	8b 45 ec             	mov    -0x14(%ebp),%eax
 565:	ba 00 00 00 00       	mov    $0x0,%edx
 56a:	f7 f3                	div    %ebx
 56c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 56f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 573:	75 c7                	jne    53c <printint+0x38>
  if(neg)
 575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 579:	74 2d                	je     5a8 <printint+0xa4>
    buf[i++] = '-';
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	8d 50 01             	lea    0x1(%eax),%edx
 581:	89 55 f4             	mov    %edx,-0xc(%ebp)
 584:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 589:	eb 1d                	jmp    5a8 <printint+0xa4>
    putc(fd, buf[i]);
 58b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 58e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 591:	01 d0                	add    %edx,%eax
 593:	0f b6 00             	movzbl (%eax),%eax
 596:	0f be c0             	movsbl %al,%eax
 599:	83 ec 08             	sub    $0x8,%esp
 59c:	50                   	push   %eax
 59d:	ff 75 08             	pushl  0x8(%ebp)
 5a0:	e8 3c ff ff ff       	call   4e1 <putc>
 5a5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5a8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b0:	79 d9                	jns    58b <printint+0x87>
    putc(fd, buf[i]);
}
 5b2:	90                   	nop
 5b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5b6:	c9                   	leave  
 5b7:	c3                   	ret    

000005b8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b8:	55                   	push   %ebp
 5b9:	89 e5                	mov    %esp,%ebp
 5bb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c8:	83 c0 04             	add    $0x4,%eax
 5cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d5:	e9 59 01 00 00       	jmp    733 <printf+0x17b>
    c = fmt[i] & 0xff;
 5da:	8b 55 0c             	mov    0xc(%ebp),%edx
 5dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e0:	01 d0                	add    %edx,%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	25 ff 00 00 00       	and    $0xff,%eax
 5ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f4:	75 2c                	jne    622 <printf+0x6a>
      if(c == '%'){
 5f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fa:	75 0c                	jne    608 <printf+0x50>
        state = '%';
 5fc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 603:	e9 27 01 00 00       	jmp    72f <printf+0x177>
      } else {
        putc(fd, c);
 608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	83 ec 08             	sub    $0x8,%esp
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	e8 c7 fe ff ff       	call   4e1 <putc>
 61a:	83 c4 10             	add    $0x10,%esp
 61d:	e9 0d 01 00 00       	jmp    72f <printf+0x177>
      }
    } else if(state == '%'){
 622:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 626:	0f 85 03 01 00 00    	jne    72f <printf+0x177>
      if(c == 'd'){
 62c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 630:	75 1e                	jne    650 <printf+0x98>
        printint(fd, *ap, 10, 1);
 632:	8b 45 e8             	mov    -0x18(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	6a 01                	push   $0x1
 639:	6a 0a                	push   $0xa
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 c0 fe ff ff       	call   504 <printint>
 644:	83 c4 10             	add    $0x10,%esp
        ap++;
 647:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64b:	e9 d8 00 00 00       	jmp    728 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 650:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 654:	74 06                	je     65c <printf+0xa4>
 656:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65a:	75 1e                	jne    67a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 65c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	6a 00                	push   $0x0
 663:	6a 10                	push   $0x10
 665:	50                   	push   %eax
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 96 fe ff ff       	call   504 <printint>
 66e:	83 c4 10             	add    $0x10,%esp
        ap++;
 671:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 675:	e9 ae 00 00 00       	jmp    728 <printf+0x170>
      } else if(c == 's'){
 67a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 67e:	75 43                	jne    6c3 <printf+0x10b>
        s = (char*)*ap;
 680:	8b 45 e8             	mov    -0x18(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 688:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 68c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 690:	75 25                	jne    6b7 <printf+0xff>
          s = "(null)";
 692:	c7 45 f4 0b 0a 00 00 	movl   $0xa0b,-0xc(%ebp)
        while(*s != 0){
 699:	eb 1c                	jmp    6b7 <printf+0xff>
          putc(fd, *s);
 69b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	0f be c0             	movsbl %al,%eax
 6a4:	83 ec 08             	sub    $0x8,%esp
 6a7:	50                   	push   %eax
 6a8:	ff 75 08             	pushl  0x8(%ebp)
 6ab:	e8 31 fe ff ff       	call   4e1 <putc>
 6b0:	83 c4 10             	add    $0x10,%esp
          s++;
 6b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ba:	0f b6 00             	movzbl (%eax),%eax
 6bd:	84 c0                	test   %al,%al
 6bf:	75 da                	jne    69b <printf+0xe3>
 6c1:	eb 65                	jmp    728 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6c7:	75 1d                	jne    6e6 <printf+0x12e>
        putc(fd, *ap);
 6c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	0f be c0             	movsbl %al,%eax
 6d1:	83 ec 08             	sub    $0x8,%esp
 6d4:	50                   	push   %eax
 6d5:	ff 75 08             	pushl  0x8(%ebp)
 6d8:	e8 04 fe ff ff       	call   4e1 <putc>
 6dd:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e4:	eb 42                	jmp    728 <printf+0x170>
      } else if(c == '%'){
 6e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ea:	75 17                	jne    703 <printf+0x14b>
        putc(fd, c);
 6ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ef:	0f be c0             	movsbl %al,%eax
 6f2:	83 ec 08             	sub    $0x8,%esp
 6f5:	50                   	push   %eax
 6f6:	ff 75 08             	pushl  0x8(%ebp)
 6f9:	e8 e3 fd ff ff       	call   4e1 <putc>
 6fe:	83 c4 10             	add    $0x10,%esp
 701:	eb 25                	jmp    728 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 703:	83 ec 08             	sub    $0x8,%esp
 706:	6a 25                	push   $0x25
 708:	ff 75 08             	pushl  0x8(%ebp)
 70b:	e8 d1 fd ff ff       	call   4e1 <putc>
 710:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 716:	0f be c0             	movsbl %al,%eax
 719:	83 ec 08             	sub    $0x8,%esp
 71c:	50                   	push   %eax
 71d:	ff 75 08             	pushl  0x8(%ebp)
 720:	e8 bc fd ff ff       	call   4e1 <putc>
 725:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 728:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 72f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 733:	8b 55 0c             	mov    0xc(%ebp),%edx
 736:	8b 45 f0             	mov    -0x10(%ebp),%eax
 739:	01 d0                	add    %edx,%eax
 73b:	0f b6 00             	movzbl (%eax),%eax
 73e:	84 c0                	test   %al,%al
 740:	0f 85 94 fe ff ff    	jne    5da <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 746:	90                   	nop
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74f:	8b 45 08             	mov    0x8(%ebp),%eax
 752:	83 e8 08             	sub    $0x8,%eax
 755:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 75d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 760:	eb 24                	jmp    786 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76a:	77 12                	ja     77e <free+0x35>
 76c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 772:	77 24                	ja     798 <free+0x4f>
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77c:	77 1a                	ja     798 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	8b 00                	mov    (%eax),%eax
 783:	89 45 fc             	mov    %eax,-0x4(%ebp)
 786:	8b 45 f8             	mov    -0x8(%ebp),%eax
 789:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78c:	76 d4                	jbe    762 <free+0x19>
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 796:	76 ca                	jbe    762 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	01 c2                	add    %eax,%edx
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	39 c2                	cmp    %eax,%edx
 7b1:	75 24                	jne    7d7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b6:	8b 50 04             	mov    0x4(%eax),%edx
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	01 c2                	add    %eax,%edx
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	8b 10                	mov    (%eax),%edx
 7d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d3:	89 10                	mov    %edx,(%eax)
 7d5:	eb 0a                	jmp    7e1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	01 d0                	add    %edx,%eax
 7f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f6:	75 20                	jne    818 <free+0xcf>
    p->s.size += bp->s.size;
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 50 04             	mov    0x4(%eax),%edx
 7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	01 c2                	add    %eax,%edx
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
 816:	eb 08                	jmp    820 <free+0xd7>
  } else
    p->s.ptr = bp;
 818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 81e:	89 10                	mov    %edx,(%eax)
  freep = p;
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 828:	90                   	nop
 829:	c9                   	leave  
 82a:	c3                   	ret    

0000082b <morecore>:

static Header*
morecore(uint nu)
{
 82b:	55                   	push   %ebp
 82c:	89 e5                	mov    %esp,%ebp
 82e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 831:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 838:	77 07                	ja     841 <morecore+0x16>
    nu = 4096;
 83a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 841:	8b 45 08             	mov    0x8(%ebp),%eax
 844:	c1 e0 03             	shl    $0x3,%eax
 847:	83 ec 0c             	sub    $0xc,%esp
 84a:	50                   	push   %eax
 84b:	e8 31 fc ff ff       	call   481 <sbrk>
 850:	83 c4 10             	add    $0x10,%esp
 853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 856:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85a:	75 07                	jne    863 <morecore+0x38>
    return 0;
 85c:	b8 00 00 00 00       	mov    $0x0,%eax
 861:	eb 26                	jmp    889 <morecore+0x5e>
  hp = (Header*)p;
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	8b 55 08             	mov    0x8(%ebp),%edx
 86f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 872:	8b 45 f0             	mov    -0x10(%ebp),%eax
 875:	83 c0 08             	add    $0x8,%eax
 878:	83 ec 0c             	sub    $0xc,%esp
 87b:	50                   	push   %eax
 87c:	e8 c8 fe ff ff       	call   749 <free>
 881:	83 c4 10             	add    $0x10,%esp
  return freep;
 884:	a1 0c 0d 00 00       	mov    0xd0c,%eax
}
 889:	c9                   	leave  
 88a:	c3                   	ret    

0000088b <malloc>:

void*
malloc(uint nbytes)
{
 88b:	55                   	push   %ebp
 88c:	89 e5                	mov    %esp,%ebp
 88e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 891:	8b 45 08             	mov    0x8(%ebp),%eax
 894:	83 c0 07             	add    $0x7,%eax
 897:	c1 e8 03             	shr    $0x3,%eax
 89a:	83 c0 01             	add    $0x1,%eax
 89d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a0:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 8a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ac:	75 23                	jne    8d1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8ae:	c7 45 f0 04 0d 00 00 	movl   $0xd04,-0x10(%ebp)
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	a3 0c 0d 00 00       	mov    %eax,0xd0c
 8bd:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 8c2:	a3 04 0d 00 00       	mov    %eax,0xd04
    base.s.size = 0;
 8c7:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 8ce:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	8b 40 04             	mov    0x4(%eax),%eax
 8df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e2:	72 4d                	jb     931 <malloc+0xa6>
      if(p->s.size == nunits)
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 40 04             	mov    0x4(%eax),%eax
 8ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ed:	75 0c                	jne    8fb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	8b 10                	mov    (%eax),%edx
 8f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f7:	89 10                	mov    %edx,(%eax)
 8f9:	eb 26                	jmp    921 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fe:	8b 40 04             	mov    0x4(%eax),%eax
 901:	2b 45 ec             	sub    -0x14(%ebp),%eax
 904:	89 c2                	mov    %eax,%edx
 906:	8b 45 f4             	mov    -0xc(%ebp),%eax
 909:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	8b 40 04             	mov    0x4(%eax),%eax
 912:	c1 e0 03             	shl    $0x3,%eax
 915:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 91e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 921:	8b 45 f0             	mov    -0x10(%ebp),%eax
 924:	a3 0c 0d 00 00       	mov    %eax,0xd0c
      return (void*)(p + 1);
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	83 c0 08             	add    $0x8,%eax
 92f:	eb 3b                	jmp    96c <malloc+0xe1>
    }
    if(p == freep)
 931:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 936:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 939:	75 1e                	jne    959 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 93b:	83 ec 0c             	sub    $0xc,%esp
 93e:	ff 75 ec             	pushl  -0x14(%ebp)
 941:	e8 e5 fe ff ff       	call   82b <morecore>
 946:	83 c4 10             	add    $0x10,%esp
 949:	89 45 f4             	mov    %eax,-0xc(%ebp)
 94c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 950:	75 07                	jne    959 <malloc+0xce>
        return 0;
 952:	b8 00 00 00 00       	mov    $0x0,%eax
 957:	eb 13                	jmp    96c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 959:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	8b 00                	mov    (%eax),%eax
 964:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 967:	e9 6d ff ff ff       	jmp    8d9 <malloc+0x4e>
}
 96c:	c9                   	leave  
 96d:	c3                   	ret    
