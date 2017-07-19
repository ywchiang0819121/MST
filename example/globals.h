#pragma once
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
#include <iomanip>
#include <thrust\host_vector.h>
#include <thrust\device_vector.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/execution_policy.h>
#include <thrust/for_each.h>
#include <thrust\copy.h>
#include <thrust\fill.h>
#include <vector>
#include <stdio.h>
#include <set>

using std::cout;
using std::endl;
using std::vector;
using std::set;
using thrust::host_vector;
using thrust::device_vector;
using thrust::device_pointer_cast;

const int V = 4, E = 5;
int cross_edge = 0;
typedef struct { int a, b, c; }bounder;// edge list
host_vector<bounder> edge;
host_vector<int> minweight(V);   // 各棵MSS的最小聯外邊的權重
host_vector<int> selectedbounders(V); // 各棵MSS的最小聯外邊的索引值
thrust::counting_iterator<int> first(0);
// Disjoint-sets Forest
host_vector<int> p(V);

device_vector<bounder> cudaedge;
device_vector<int> cudaselectedbounders(selectedbounders);
device_vector<int> cudap(p);
device_vector<int> cudaminweight(minweight);
__device__ int* cudaptrsb;
__device__ int* cudaptrp;
__device__ int* cudaptrmw;