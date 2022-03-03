#!/usr/bin/env bash


# Example
# test-composed-script -a a -b b -c c

echo 'A'
test-hello-figlet-cowsay
echo 'B'

number_of_arguments="$#"

echo $number_of_arguments

while [ $number_of_arguments -gt 0 ]; do
  # echo '$# '$#
  should_shift='true'

  case "$1" in
    -a|-a_in_long_form|--a_in_long_form)
      A_IN_LONG_FORM="$2"
      ;;
    -b|-b_in_long_form|--b_in_long_form)
      B_IN_LONG_FORM="$2"
      ;;
    *)
      # printf "***************************\n"
      # printf "* Error: Invalid argument.*\n"
      # printf "***************************\n"
      echo 'Argument passed down!'
      echo "$1"
      echo "$2"
      should_shift='false'
      # continue
      # exit 1
  esac

  if [ "$should_shift" == 'true' ]; then
    shift
    shift
  fi

  number_of_arguments="$((number_of_arguments - 1))"
done


A_IN_LONG_FORM=${A_IN_LONG_FORM:-AW}
B_IN_LONG_FORM=${B_IN_LONG_FORM:-BW}

echo '$# = '$#
echo '$@ = '"$*"

shift 1
shift 1

echo '$# = '$#
echo '$@ = '"$*"
