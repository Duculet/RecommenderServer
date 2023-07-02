#!/bin/bash
#SBATCH -o ./job_outputs/EVAL%j.output
#SBATCH -e ./job_outputs/EVAL%j.error
#SBATCH --job-name=Experiment_Eval
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --partition=thin

echo "Evaluation has started!"

# if argument is not provided, set default value to TT
# else set the experiment to argument value
experiment=${1:-TT}

# if argument is not provided, set default value to 100
# else set limit to argument value
limit_t=${2:-100}

echo "Experiment $experiment begins with limit $limit_t"

models_dir=$HOME/experiments/$experiment/pbfiles/train
datasets_dir=$HOME/experiments/$experiment/tsvfiles/test
output_dir=$HOME/experiments/$experiment/evaluation

for dataset in "$datasets_dir"/*
do
    # if dataset is smaller than limit, skip it
    # else run evaluation
    if [ $(wc -l < $dataset) -lt $limit_t ]
    then
        echo "Skipping $dataset"
        continue
    fi
    model=$models_dir/$(basename $dataset).schemaTree.typed.pb
    echo "Running $model"
    echo "Against $dataset"
    $HOME/QualRecommender evaluate -m $model -d $dataset -o $output_dir 
    echo "Saved in $output_dir"
done

echo "$experiment done!"

echo "Evaluation has finished!"