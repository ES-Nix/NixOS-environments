#!/usr/bin/env bash



while [ $# -gt 0 ]; do
  case "$1" in
    -a|-arg_1|--arg_1)
      arg_1="$2"
      ;;
    -p|-p_out|--p_out)
      p_out="$2"
      ;;
    -p0|-p_out0|--p_out0)
      p_out_zxw_0="$2"
      ;;
    -p1|-p_out1|--p_out1)
      p_out_zxw_1="$2"
      ;;
    -p2|-p_out2|--p_out2)
      p_out_zxw_2="$2"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
  shift
done


p_out=${p_out:-"p"}
p_out_zxw_0=${p_out_zxw_0:-"0"}
p_out_zxw_1=${p_out_zxw_1:-"1"}
p_out_zxw_2=${p_out_zxw_2:-"2"}


#echo "$p_out"
#echo "$p_out_zxw_0"
#echo "$p_out_zxw_1"
#echo "$p_out_zxw_2"
