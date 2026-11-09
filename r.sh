#!/data/data/com.termux/files/usr/bin/sh
# 노트9 Termux 원격 접속(SSH) 준비 스크립트
# - openssh 설치
# - 대시보드 PC의 공개 열쇠만 접속 허용 (비밀번호 접속 없음)
# - SSH 서버 실행, 화면이 꺼져도 Termux가 멈추지 않게 유지
set -e

echo "1/4 패키지 목록을 새로 받는 중..."
yes | pkg update

echo "2/4 원격 접속 프로그램(openssh) 설치 중..."
pkg install -y openssh

echo "3/4 PC 열쇠 등록 중..."
mkdir -p ~/.ssh
KEY=$(curl -fsSL https://chldlsdn119.github.io/home-hub/pc.pub)
touch ~/.ssh/authorized_keys
grep -qF "$KEY" ~/.ssh/authorized_keys || echo "$KEY" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
# 비밀번호로는 접속할 수 없게
mkdir -p "$PREFIX/etc/ssh"
grep -q '^PasswordAuthentication no' "$PREFIX/etc/ssh/sshd_config" 2>/dev/null || echo 'PasswordAuthentication no' >> "$PREFIX/etc/ssh/sshd_config"

echo "4/4 원격 접속 켜는 중..."
pkill sshd 2>/dev/null || true
sshd
termux-wake-lock

echo ""
echo "완료! 원격 접속이 켜졌어요 (포트 8022)."
echo "노트9의 와이파이 IP 주소를 PC에 알려 주세요."
