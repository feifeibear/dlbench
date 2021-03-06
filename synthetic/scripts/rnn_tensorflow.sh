#!/bin/bash
network_type="${network_type:-rnn}"
network_name="${network_name:-lstm}"
tool=tensorflow

minibatch="${minibatch:-64}"
iterations="${iterations:-2000}"
device_id="${device_id:-1}"
seqlen="${seqlen:-32}"
hiddensize="${hiddensize:-256}"
numlayer="${numlayer:-2}"
default="--data_path=/home/comp/csshshi/data/tensorflow/simple-examples/data/"
benchmark_logfile=${network_type}-${network_name}-gpu${device_id}.bm

running_time=`date`

echo -e 'GPU:'${device_id}'\nNUM_THREADS (for CPU): '${OMP_NUM_THREADS}'\nNetwork: '${network_name}${numlayer}'\nSeqlen: '${seqlen}'\nMinibatch: '${minibatch}'\nIterations: '${iterations}'\nBenchmark Time: '${running_time}'\n_________________\n'>> ${benchmark_logfile}
echo -e 'ToolName\t\t\tAverageTime(s)'>>${benchmark_logfile}
tmplog=b${minibatch}-gpu${device_id}.log
python /home/comp/csshshi/TensorFlow-Examples/rnn/ptb/ptb_word_lm.py --batchsize ${minibatch} --iters ${iterations} --seqlen ${seqlen} --numlayer ${numlayer} --hiddensize ${hiddensize} --device ${device_id} ${default} >& ${tmplog}
total_time=`cat ${tmplog} | grep "Time for " | awk '{print $5}'`
time_in_second=`awk "BEGIN {print ${total_time}/${iterations}}"`

echo -e ${tool}'\t\t\t'${time_in_second}>>${benchmark_logfile}
echo -e '\n\n'>>${benchmark_logfile}

# python ptb_word_lm.py --batchsize ${minibatch} --iters ${iterations} --seqlen ${seqlen} --numlayer ${numlayer} --hiddensize ${hiddensize} --device ${device_id} ${default}
