#!/usr/bin/env bash
# 用法: ./_check.sh 文件.md [文件2.md ...]
# 校验: OCR残留 / 图片引用 / 代码围栏配对 / 行数
cd "$(dirname "$0")"
for f in "$@"; do
  [ -f "$f" ] || { echo "!! 不存在: $f"; continue; }
  ocr=$(grep -c 'OCR_START' "$f")
  img=$(grep -c '!\[' "$f")
  fence=$(grep -c '```' "$f")
  lines=$(wc -l < "$f")
  pair=$(( fence % 2 == 0 ))
  h2=$(grep -c '^## ' "$f")
  flag=""
  [ "$ocr" != "0" ] && flag="$flag [OCR=$ocr]"
  [ "$img" != "0" ] && flag="$flag [图片=$img]"
  [ "$pair" = "0" ] && flag="$flag [围栏不配对=$fence]"
  [ -z "$flag" ] && flag=" OK"
  printf "%-40s %6s行 围栏%-4s ##%-3s %s\n" "$f" "$lines" "$fence" "$h2" "$flag"
done
