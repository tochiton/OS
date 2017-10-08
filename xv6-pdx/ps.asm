
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"
#define max 64    //number of processes
int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
  // allocate my table

  struct uproc* table = malloc(max * sizeof(struct uproc));
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 00 17 00 00       	push   $0x1700
  1c:	e8 30 08 00 00       	call   851 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int result = getprocs(max, table);              // system call
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 e0             	pushl  -0x20(%ebp)
  2d:	6a 40                	push   $0x40
  2f:	e8 6b 04 00 00       	call   49f <getprocs>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 dc             	mov    %eax,-0x24(%ebp)

  printf(1,"ID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  3a:	83 ec 08             	sub    $0x8,%esp
  3d:	68 34 09 00 00       	push   $0x934
  42:	6a 01                	push   $0x1
  44:	e8 35 05 00 00       	call   57e <printf>
  49:	83 c4 10             	add    $0x10,%esp
  for(int i =0; i<result; i++){
  4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  53:	e9 b0 00 00 00       	jmp    108 <main+0x108>
    printf(1,"%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%s\t\n", table[i].pid, table[i].uid,table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].state, table[i].size, table[i].name );
  58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  5b:	6b d0 5c             	imul   $0x5c,%eax,%edx
  5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  61:	01 d0                	add    %edx,%eax
  63:	83 c0 3c             	add    $0x3c,%eax
  66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  6c:	6b d0 5c             	imul   $0x5c,%eax,%edx
  6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  72:	01 d0                	add    %edx,%eax
  74:	8b 78 38             	mov    0x38(%eax),%edi
  77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  7a:	6b d0 5c             	imul   $0x5c,%eax,%edx
  7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80:	01 d0                	add    %edx,%eax
  82:	8d 48 18             	lea    0x18(%eax),%ecx
  85:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8b:	6b d0 5c             	imul   $0x5c,%eax,%edx
  8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  91:	01 d0                	add    %edx,%eax
  93:	8b 58 14             	mov    0x14(%eax),%ebx
  96:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9c:	6b d0 5c             	imul   $0x5c,%eax,%edx
  9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a2:	01 d0                	add    %edx,%eax
  a4:	8b 70 10             	mov    0x10(%eax),%esi
  a7:	89 75 c8             	mov    %esi,-0x38(%ebp)
  aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ad:	6b d0 5c             	imul   $0x5c,%eax,%edx
  b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b3:	01 d0                	add    %edx,%eax
  b5:	8b 70 0c             	mov    0xc(%eax),%esi
  b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  bb:	6b d0 5c             	imul   $0x5c,%eax,%edx
  be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  c1:	01 d0                	add    %edx,%eax
  c3:	8b 58 08             	mov    0x8(%eax),%ebx
  c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c9:	6b d0 5c             	imul   $0x5c,%eax,%edx
  cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cf:	01 d0                	add    %edx,%eax
  d1:	8b 48 04             	mov    0x4(%eax),%ecx
  d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  d7:	6b d0 5c             	imul   $0x5c,%eax,%edx
  da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  dd:	01 d0                	add    %edx,%eax
  df:	8b 00                	mov    (%eax),%eax
  e1:	83 ec 04             	sub    $0x4,%esp
  e4:	ff 75 d4             	pushl  -0x2c(%ebp)
  e7:	57                   	push   %edi
  e8:	ff 75 d0             	pushl  -0x30(%ebp)
  eb:	ff 75 cc             	pushl  -0x34(%ebp)
  ee:	ff 75 c8             	pushl  -0x38(%ebp)
  f1:	56                   	push   %esi
  f2:	53                   	push   %ebx
  f3:	51                   	push   %ecx
  f4:	50                   	push   %eax
  f5:	68 61 09 00 00       	push   $0x961
  fa:	6a 01                	push   $0x1
  fc:	e8 7d 04 00 00       	call   57e <printf>
 101:	83 c4 30             	add    $0x30,%esp

  struct uproc* table = malloc(max * sizeof(struct uproc));
  int result = getprocs(max, table);              // system call

  printf(1,"ID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i =0; i<result; i++){
 104:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 10b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 10e:	0f 8c 44 ff ff ff    	jl     58 <main+0x58>
    printf(1,"%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%s\t\n", table[i].pid, table[i].uid,table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].state, table[i].size, table[i].name );
  }

//  printf(1,"number of processes %d\n", result);
  printf(1, "Not imlpemented yet.\n");
 114:	83 ec 08             	sub    $0x8,%esp
 117:	68 7e 09 00 00       	push   $0x97e
 11c:	6a 01                	push   $0x1
 11e:	e8 5b 04 00 00       	call   57e <printf>
 123:	83 c4 10             	add    $0x10,%esp
  exit();
 126:	e8 9c 02 00 00       	call   3c7 <exit>

0000012b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 130:	8b 4d 08             	mov    0x8(%ebp),%ecx
 133:	8b 55 10             	mov    0x10(%ebp),%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	89 cb                	mov    %ecx,%ebx
 13b:	89 df                	mov    %ebx,%edi
 13d:	89 d1                	mov    %edx,%ecx
 13f:	fc                   	cld    
 140:	f3 aa                	rep stos %al,%es:(%edi)
 142:	89 ca                	mov    %ecx,%edx
 144:	89 fb                	mov    %edi,%ebx
 146:	89 5d 08             	mov    %ebx,0x8(%ebp)
 149:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 14c:	90                   	nop
 14d:	5b                   	pop    %ebx
 14e:	5f                   	pop    %edi
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    

00000151 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 15d:	90                   	nop
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8d 50 01             	lea    0x1(%eax),%edx
 164:	89 55 08             	mov    %edx,0x8(%ebp)
 167:	8b 55 0c             	mov    0xc(%ebp),%edx
 16a:	8d 4a 01             	lea    0x1(%edx),%ecx
 16d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 170:	0f b6 12             	movzbl (%edx),%edx
 173:	88 10                	mov    %dl,(%eax)
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	75 e2                	jne    15e <strcpy+0xd>
    ;
  return os;
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 184:	eb 08                	jmp    18e <strcmp+0xd>
    p++, q++;
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	84 c0                	test   %al,%al
 196:	74 10                	je     1a8 <strcmp+0x27>
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	38 c2                	cmp    %al,%dl
 1a6:	74 de                	je     186 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	0f b6 d0             	movzbl %al,%edx
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	0f b6 c0             	movzbl %al,%eax
 1ba:	29 c2                	sub    %eax,%edx
 1bc:	89 d0                	mov    %edx,%eax
}
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    

000001c0 <strlen>:

uint
strlen(char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cd:	eb 04                	jmp    1d3 <strlen+0x13>
 1cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	75 ed                	jne    1cf <strlen+0xf>
    ;
  return n;
 1e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ea:	8b 45 10             	mov    0x10(%ebp),%eax
 1ed:	50                   	push   %eax
 1ee:	ff 75 0c             	pushl  0xc(%ebp)
 1f1:	ff 75 08             	pushl  0x8(%ebp)
 1f4:	e8 32 ff ff ff       	call   12b <stosb>
 1f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <strchr>:

char*
strchr(const char *s, char c)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 04             	sub    $0x4,%esp
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20d:	eb 14                	jmp    223 <strchr+0x22>
    if(*s == c)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	3a 45 fc             	cmp    -0x4(%ebp),%al
 218:	75 05                	jne    21f <strchr+0x1e>
      return (char*)s;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	eb 13                	jmp    232 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 e2                	jne    20f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <gets>:

char*
gets(char *buf, int max)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 241:	eb 42                	jmp    285 <gets+0x51>
    cc = read(0, &c, 1);
 243:	83 ec 04             	sub    $0x4,%esp
 246:	6a 01                	push   $0x1
 248:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24b:	50                   	push   %eax
 24c:	6a 00                	push   $0x0
 24e:	e8 8c 01 00 00       	call   3df <read>
 253:	83 c4 10             	add    $0x10,%esp
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25d:	7e 33                	jle    292 <gets+0x5e>
      break;
    buf[i++] = c;
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 f4             	mov    %edx,-0xc(%ebp)
 268:	89 c2                	mov    %eax,%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 c2                	add    %eax,%edx
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 16                	je     293 <gets+0x5f>
 27d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 281:	3c 0d                	cmp    $0xd,%al
 283:	74 0e                	je     293 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 285:	8b 45 f4             	mov    -0xc(%ebp),%eax
 288:	83 c0 01             	add    $0x1,%eax
 28b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28e:	7c b3                	jl     243 <gets+0xf>
 290:	eb 01                	jmp    293 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 292:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 293:	8b 55 f4             	mov    -0xc(%ebp),%edx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	01 d0                	add    %edx,%eax
 29b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <stat>:

int
stat(char *n, struct stat *st)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	6a 00                	push   $0x0
 2ae:	ff 75 08             	pushl  0x8(%ebp)
 2b1:	e8 51 01 00 00       	call   407 <open>
 2b6:	83 c4 10             	add    $0x10,%esp
 2b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c0:	79 07                	jns    2c9 <stat+0x26>
    return -1;
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 25                	jmp    2ee <stat+0x4b>
  r = fstat(fd, st);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	ff 75 0c             	pushl  0xc(%ebp)
 2cf:	ff 75 f4             	pushl  -0xc(%ebp)
 2d2:	e8 48 01 00 00       	call   41f <fstat>
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2dd:	83 ec 0c             	sub    $0xc,%esp
 2e0:	ff 75 f4             	pushl  -0xc(%ebp)
 2e3:	e8 07 01 00 00       	call   3ef <close>
 2e8:	83 c4 10             	add    $0x10,%esp
  return r;
 2eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ee:	c9                   	leave  
 2ef:	c3                   	ret    

000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2fd:	eb 04                	jmp    303 <atoi+0x13>
 2ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	3c 20                	cmp    $0x20,%al
 30b:	74 f2                	je     2ff <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	0f b6 00             	movzbl (%eax),%eax
 313:	3c 2d                	cmp    $0x2d,%al
 315:	75 07                	jne    31e <atoi+0x2e>
 317:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31c:	eb 05                	jmp    323 <atoi+0x33>
 31e:	b8 01 00 00 00       	mov    $0x1,%eax
 323:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	3c 2b                	cmp    $0x2b,%al
 32e:	74 0a                	je     33a <atoi+0x4a>
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	0f b6 00             	movzbl (%eax),%eax
 336:	3c 2d                	cmp    $0x2d,%al
 338:	75 2b                	jne    365 <atoi+0x75>
    s++;
 33a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 33e:	eb 25                	jmp    365 <atoi+0x75>
    n = n*10 + *s++ - '0';
 340:	8b 55 fc             	mov    -0x4(%ebp),%edx
 343:	89 d0                	mov    %edx,%eax
 345:	c1 e0 02             	shl    $0x2,%eax
 348:	01 d0                	add    %edx,%eax
 34a:	01 c0                	add    %eax,%eax
 34c:	89 c1                	mov    %eax,%ecx
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	8d 50 01             	lea    0x1(%eax),%edx
 354:	89 55 08             	mov    %edx,0x8(%ebp)
 357:	0f b6 00             	movzbl (%eax),%eax
 35a:	0f be c0             	movsbl %al,%eax
 35d:	01 c8                	add    %ecx,%eax
 35f:	83 e8 30             	sub    $0x30,%eax
 362:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	3c 2f                	cmp    $0x2f,%al
 36d:	7e 0a                	jle    379 <atoi+0x89>
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	0f b6 00             	movzbl (%eax),%eax
 375:	3c 39                	cmp    $0x39,%al
 377:	7e c7                	jle    340 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 379:	8b 45 f8             	mov    -0x8(%ebp),%eax
 37c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 394:	eb 17                	jmp    3ad <memmove+0x2b>
    *dst++ = *src++;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
 399:	8d 50 01             	lea    0x1(%eax),%edx
 39c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 39f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a2:	8d 4a 01             	lea    0x1(%edx),%ecx
 3a5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3a8:	0f b6 12             	movzbl (%edx),%edx
 3ab:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ad:	8b 45 10             	mov    0x10(%ebp),%eax
 3b0:	8d 50 ff             	lea    -0x1(%eax),%edx
 3b3:	89 55 10             	mov    %edx,0x10(%ebp)
 3b6:	85 c0                	test   %eax,%eax
 3b8:	7f dc                	jg     396 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3bd:	c9                   	leave  
 3be:	c3                   	ret    

000003bf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3bf:	b8 01 00 00 00       	mov    $0x1,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <exit>:
SYSCALL(exit)
 3c7:	b8 02 00 00 00       	mov    $0x2,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <wait>:
SYSCALL(wait)
 3cf:	b8 03 00 00 00       	mov    $0x3,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <pipe>:
SYSCALL(pipe)
 3d7:	b8 04 00 00 00       	mov    $0x4,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <read>:
SYSCALL(read)
 3df:	b8 05 00 00 00       	mov    $0x5,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <write>:
SYSCALL(write)
 3e7:	b8 10 00 00 00       	mov    $0x10,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <close>:
SYSCALL(close)
 3ef:	b8 15 00 00 00       	mov    $0x15,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <kill>:
SYSCALL(kill)
 3f7:	b8 06 00 00 00       	mov    $0x6,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <exec>:
SYSCALL(exec)
 3ff:	b8 07 00 00 00       	mov    $0x7,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <open>:
SYSCALL(open)
 407:	b8 0f 00 00 00       	mov    $0xf,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <mknod>:
SYSCALL(mknod)
 40f:	b8 11 00 00 00       	mov    $0x11,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <unlink>:
SYSCALL(unlink)
 417:	b8 12 00 00 00       	mov    $0x12,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <fstat>:
SYSCALL(fstat)
 41f:	b8 08 00 00 00       	mov    $0x8,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <link>:
SYSCALL(link)
 427:	b8 13 00 00 00       	mov    $0x13,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <mkdir>:
SYSCALL(mkdir)
 42f:	b8 14 00 00 00       	mov    $0x14,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <chdir>:
SYSCALL(chdir)
 437:	b8 09 00 00 00       	mov    $0x9,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <dup>:
SYSCALL(dup)
 43f:	b8 0a 00 00 00       	mov    $0xa,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <getpid>:
SYSCALL(getpid)
 447:	b8 0b 00 00 00       	mov    $0xb,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <sbrk>:
SYSCALL(sbrk)
 44f:	b8 0c 00 00 00       	mov    $0xc,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <sleep>:
SYSCALL(sleep)
 457:	b8 0d 00 00 00       	mov    $0xd,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <uptime>:
SYSCALL(uptime)
 45f:	b8 0e 00 00 00       	mov    $0xe,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <halt>:
SYSCALL(halt)
 467:	b8 16 00 00 00       	mov    $0x16,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <date>:
SYSCALL(date)
 46f:	b8 17 00 00 00       	mov    $0x17,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <getuid>:
SYSCALL(getuid)
 477:	b8 18 00 00 00       	mov    $0x18,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <getgid>:
SYSCALL(getgid)
 47f:	b8 19 00 00 00       	mov    $0x19,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <getppid>:
SYSCALL(getppid)
 487:	b8 1a 00 00 00       	mov    $0x1a,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <setuid>:
SYSCALL(setuid)
 48f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <setgid>:
SYSCALL(setgid)
 497:	b8 1c 00 00 00       	mov    $0x1c,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <getprocs>:
SYSCALL(getprocs)
 49f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a7:	55                   	push   %ebp
 4a8:	89 e5                	mov    %esp,%ebp
 4aa:	83 ec 18             	sub    $0x18,%esp
 4ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b3:	83 ec 04             	sub    $0x4,%esp
 4b6:	6a 01                	push   $0x1
 4b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4bb:	50                   	push   %eax
 4bc:	ff 75 08             	pushl  0x8(%ebp)
 4bf:	e8 23 ff ff ff       	call   3e7 <write>
 4c4:	83 c4 10             	add    $0x10,%esp
}
 4c7:	90                   	nop
 4c8:	c9                   	leave  
 4c9:	c3                   	ret    

000004ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ca:	55                   	push   %ebp
 4cb:	89 e5                	mov    %esp,%ebp
 4cd:	53                   	push   %ebx
 4ce:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4dc:	74 17                	je     4f5 <printint+0x2b>
 4de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e2:	79 11                	jns    4f5 <printint+0x2b>
    neg = 1;
 4e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ee:	f7 d8                	neg    %eax
 4f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f3:	eb 06                	jmp    4fb <printint+0x31>
  } else {
    x = xx;
 4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 502:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 505:	8d 41 01             	lea    0x1(%ecx),%eax
 508:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 511:	ba 00 00 00 00       	mov    $0x0,%edx
 516:	f7 f3                	div    %ebx
 518:	89 d0                	mov    %edx,%eax
 51a:	0f b6 80 f0 0b 00 00 	movzbl 0xbf0(%eax),%eax
 521:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 525:	8b 5d 10             	mov    0x10(%ebp),%ebx
 528:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52b:	ba 00 00 00 00       	mov    $0x0,%edx
 530:	f7 f3                	div    %ebx
 532:	89 45 ec             	mov    %eax,-0x14(%ebp)
 535:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 539:	75 c7                	jne    502 <printint+0x38>
  if(neg)
 53b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53f:	74 2d                	je     56e <printint+0xa4>
    buf[i++] = '-';
 541:	8b 45 f4             	mov    -0xc(%ebp),%eax
 544:	8d 50 01             	lea    0x1(%eax),%edx
 547:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 54f:	eb 1d                	jmp    56e <printint+0xa4>
    putc(fd, buf[i]);
 551:	8d 55 dc             	lea    -0x24(%ebp),%edx
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	01 d0                	add    %edx,%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	83 ec 08             	sub    $0x8,%esp
 562:	50                   	push   %eax
 563:	ff 75 08             	pushl  0x8(%ebp)
 566:	e8 3c ff ff ff       	call   4a7 <putc>
 56b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 56e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 576:	79 d9                	jns    551 <printint+0x87>
    putc(fd, buf[i]);
}
 578:	90                   	nop
 579:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 57c:	c9                   	leave  
 57d:	c3                   	ret    

0000057e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 57e:	55                   	push   %ebp
 57f:	89 e5                	mov    %esp,%ebp
 581:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58b:	8d 45 0c             	lea    0xc(%ebp),%eax
 58e:	83 c0 04             	add    $0x4,%eax
 591:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59b:	e9 59 01 00 00       	jmp    6f9 <printf+0x17b>
    c = fmt[i] & 0xff;
 5a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a6:	01 d0                	add    %edx,%eax
 5a8:	0f b6 00             	movzbl (%eax),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	25 ff 00 00 00       	and    $0xff,%eax
 5b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ba:	75 2c                	jne    5e8 <printf+0x6a>
      if(c == '%'){
 5bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c0:	75 0c                	jne    5ce <printf+0x50>
        state = '%';
 5c2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c9:	e9 27 01 00 00       	jmp    6f5 <printf+0x177>
      } else {
        putc(fd, c);
 5ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	50                   	push   %eax
 5d8:	ff 75 08             	pushl  0x8(%ebp)
 5db:	e8 c7 fe ff ff       	call   4a7 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
 5e3:	e9 0d 01 00 00       	jmp    6f5 <printf+0x177>
      }
    } else if(state == '%'){
 5e8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ec:	0f 85 03 01 00 00    	jne    6f5 <printf+0x177>
      if(c == 'd'){
 5f2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f6:	75 1e                	jne    616 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	6a 01                	push   $0x1
 5ff:	6a 0a                	push   $0xa
 601:	50                   	push   %eax
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	e8 c0 fe ff ff       	call   4ca <printint>
 60a:	83 c4 10             	add    $0x10,%esp
        ap++;
 60d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 611:	e9 d8 00 00 00       	jmp    6ee <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 616:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61a:	74 06                	je     622 <printf+0xa4>
 61c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 620:	75 1e                	jne    640 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 622:	8b 45 e8             	mov    -0x18(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	6a 00                	push   $0x0
 629:	6a 10                	push   $0x10
 62b:	50                   	push   %eax
 62c:	ff 75 08             	pushl  0x8(%ebp)
 62f:	e8 96 fe ff ff       	call   4ca <printint>
 634:	83 c4 10             	add    $0x10,%esp
        ap++;
 637:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63b:	e9 ae 00 00 00       	jmp    6ee <printf+0x170>
      } else if(c == 's'){
 640:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 644:	75 43                	jne    689 <printf+0x10b>
        s = (char*)*ap;
 646:	8b 45 e8             	mov    -0x18(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 64e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 656:	75 25                	jne    67d <printf+0xff>
          s = "(null)";
 658:	c7 45 f4 94 09 00 00 	movl   $0x994,-0xc(%ebp)
        while(*s != 0){
 65f:	eb 1c                	jmp    67d <printf+0xff>
          putc(fd, *s);
 661:	8b 45 f4             	mov    -0xc(%ebp),%eax
 664:	0f b6 00             	movzbl (%eax),%eax
 667:	0f be c0             	movsbl %al,%eax
 66a:	83 ec 08             	sub    $0x8,%esp
 66d:	50                   	push   %eax
 66e:	ff 75 08             	pushl  0x8(%ebp)
 671:	e8 31 fe ff ff       	call   4a7 <putc>
 676:	83 c4 10             	add    $0x10,%esp
          s++;
 679:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 67d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 680:	0f b6 00             	movzbl (%eax),%eax
 683:	84 c0                	test   %al,%al
 685:	75 da                	jne    661 <printf+0xe3>
 687:	eb 65                	jmp    6ee <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 689:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68d:	75 1d                	jne    6ac <printf+0x12e>
        putc(fd, *ap);
 68f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	0f be c0             	movsbl %al,%eax
 697:	83 ec 08             	sub    $0x8,%esp
 69a:	50                   	push   %eax
 69b:	ff 75 08             	pushl  0x8(%ebp)
 69e:	e8 04 fe ff ff       	call   4a7 <putc>
 6a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6aa:	eb 42                	jmp    6ee <printf+0x170>
      } else if(c == '%'){
 6ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b0:	75 17                	jne    6c9 <printf+0x14b>
        putc(fd, c);
 6b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b5:	0f be c0             	movsbl %al,%eax
 6b8:	83 ec 08             	sub    $0x8,%esp
 6bb:	50                   	push   %eax
 6bc:	ff 75 08             	pushl  0x8(%ebp)
 6bf:	e8 e3 fd ff ff       	call   4a7 <putc>
 6c4:	83 c4 10             	add    $0x10,%esp
 6c7:	eb 25                	jmp    6ee <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c9:	83 ec 08             	sub    $0x8,%esp
 6cc:	6a 25                	push   $0x25
 6ce:	ff 75 08             	pushl  0x8(%ebp)
 6d1:	e8 d1 fd ff ff       	call   4a7 <putc>
 6d6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6dc:	0f be c0             	movsbl %al,%eax
 6df:	83 ec 08             	sub    $0x8,%esp
 6e2:	50                   	push   %eax
 6e3:	ff 75 08             	pushl  0x8(%ebp)
 6e6:	e8 bc fd ff ff       	call   4a7 <putc>
 6eb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	01 d0                	add    %edx,%eax
 701:	0f b6 00             	movzbl (%eax),%eax
 704:	84 c0                	test   %al,%al
 706:	0f 85 94 fe ff ff    	jne    5a0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 70c:	90                   	nop
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	83 e8 08             	sub    $0x8,%eax
 71b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 723:	89 45 fc             	mov    %eax,-0x4(%ebp)
 726:	eb 24                	jmp    74c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 730:	77 12                	ja     744 <free+0x35>
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 738:	77 24                	ja     75e <free+0x4f>
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 742:	77 1a                	ja     75e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 752:	76 d4                	jbe    728 <free+0x19>
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75c:	76 ca                	jbe    728 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 40 04             	mov    0x4(%eax),%eax
 764:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	01 c2                	add    %eax,%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	39 c2                	cmp    %eax,%edx
 777:	75 24                	jne    79d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	8b 50 04             	mov    0x4(%eax),%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 00                	mov    (%eax),%eax
 794:	8b 10                	mov    (%eax),%edx
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	89 10                	mov    %edx,(%eax)
 79b:	eb 0a                	jmp    7a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 10                	mov    (%eax),%edx
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	01 d0                	add    %edx,%eax
 7b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bc:	75 20                	jne    7de <free+0xcf>
    p->s.size += bp->s.size;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 50 04             	mov    0x4(%eax),%edx
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	01 c2                	add    %eax,%edx
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
 7dc:	eb 08                	jmp    7e6 <free+0xd7>
  } else
    p->s.ptr = bp;
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	a3 0c 0c 00 00       	mov    %eax,0xc0c
}
 7ee:	90                   	nop
 7ef:	c9                   	leave  
 7f0:	c3                   	ret    

000007f1 <morecore>:

static Header*
morecore(uint nu)
{
 7f1:	55                   	push   %ebp
 7f2:	89 e5                	mov    %esp,%ebp
 7f4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7fe:	77 07                	ja     807 <morecore+0x16>
    nu = 4096;
 800:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	c1 e0 03             	shl    $0x3,%eax
 80d:	83 ec 0c             	sub    $0xc,%esp
 810:	50                   	push   %eax
 811:	e8 39 fc ff ff       	call   44f <sbrk>
 816:	83 c4 10             	add    $0x10,%esp
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 81c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 820:	75 07                	jne    829 <morecore+0x38>
    return 0;
 822:	b8 00 00 00 00       	mov    $0x0,%eax
 827:	eb 26                	jmp    84f <morecore+0x5e>
  hp = (Header*)p;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	8b 55 08             	mov    0x8(%ebp),%edx
 835:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	83 c0 08             	add    $0x8,%eax
 83e:	83 ec 0c             	sub    $0xc,%esp
 841:	50                   	push   %eax
 842:	e8 c8 fe ff ff       	call   70f <free>
 847:	83 c4 10             	add    $0x10,%esp
  return freep;
 84a:	a1 0c 0c 00 00       	mov    0xc0c,%eax
}
 84f:	c9                   	leave  
 850:	c3                   	ret    

00000851 <malloc>:

void*
malloc(uint nbytes)
{
 851:	55                   	push   %ebp
 852:	89 e5                	mov    %esp,%ebp
 854:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 857:	8b 45 08             	mov    0x8(%ebp),%eax
 85a:	83 c0 07             	add    $0x7,%eax
 85d:	c1 e8 03             	shr    $0x3,%eax
 860:	83 c0 01             	add    $0x1,%eax
 863:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 866:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 872:	75 23                	jne    897 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 874:	c7 45 f0 04 0c 00 00 	movl   $0xc04,-0x10(%ebp)
 87b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87e:	a3 0c 0c 00 00       	mov    %eax,0xc0c
 883:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 888:	a3 04 0c 00 00       	mov    %eax,0xc04
    base.s.size = 0;
 88d:	c7 05 08 0c 00 00 00 	movl   $0x0,0xc08
 894:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 897:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	8b 40 04             	mov    0x4(%eax),%eax
 8a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a8:	72 4d                	jb     8f7 <malloc+0xa6>
      if(p->s.size == nunits)
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b3:	75 0c                	jne    8c1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 10                	mov    (%eax),%edx
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	89 10                	mov    %edx,(%eax)
 8bf:	eb 26                	jmp    8e7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c4:	8b 40 04             	mov    0x4(%eax),%eax
 8c7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ca:	89 c2                	mov    %eax,%edx
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	8b 40 04             	mov    0x4(%eax),%eax
 8d8:	c1 e0 03             	shl    $0x3,%eax
 8db:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ea:	a3 0c 0c 00 00       	mov    %eax,0xc0c
      return (void*)(p + 1);
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	83 c0 08             	add    $0x8,%eax
 8f5:	eb 3b                	jmp    932 <malloc+0xe1>
    }
    if(p == freep)
 8f7:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 8fc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ff:	75 1e                	jne    91f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 901:	83 ec 0c             	sub    $0xc,%esp
 904:	ff 75 ec             	pushl  -0x14(%ebp)
 907:	e8 e5 fe ff ff       	call   7f1 <morecore>
 90c:	83 c4 10             	add    $0x10,%esp
 90f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 916:	75 07                	jne    91f <malloc+0xce>
        return 0;
 918:	b8 00 00 00 00       	mov    $0x0,%eax
 91d:	eb 13                	jmp    932 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	89 45 f0             	mov    %eax,-0x10(%ebp)
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 92d:	e9 6d ff ff ff       	jmp    89f <malloc+0x4e>
}
 932:	c9                   	leave  
 933:	c3                   	ret    
