// Copyright 2018 Delft University of Technology
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <chrono>
#include <memory>
#include <vector>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <random>
#include <stdlib.h>
#include <unistd.h>

// Apache Arrow
#include <arrow/api.h>
#include <arrow/io/api.h>
#include <parquet/arrow/reader.h>
#include <parquet/arrow/writer.h>

#include <fletcher/api.h>

#ifdef SV_TEST
#include "fletcher_aws_sim.h"
#endif

#define MAX_STRBUF_SIZE 256
#define NAME_SUFFIX_LENGTH 7 // 000.rb (3 numbers, 3 chars, and a terminator)
#define OUT_REG_BASE 176     // 0xB)

// Prepare recordbatch to hold the output data
std::shared_ptr<arrow::RecordBatch> PrepareRecordBatch(int32_t num_strings, int32_t num_chars, int32_t num_rows)
{
  std::shared_ptr<arrow::Buffer> l_returnflag_offsets;
  std::shared_ptr<arrow::Buffer> l_returnflag_values;
  std::shared_ptr<arrow::Buffer> sum_qty, sum_base_price, sum_disc_price, sum_charge, avg_qty, avg_price, avg_disc, count_order;

  l_returnflag_offsets = arrow::AllocateBuffer(sizeof(int32_t) * (num_strings + 1)).ValueOrDie();
  l_returnflag_values = arrow::AllocateBuffer(num_chars).ValueOrDie();

  std::shared_ptr<arrow::Buffer> l_linestatus_offsets;
  std::shared_ptr<arrow::Buffer> l_linestatus_values;
  l_linestatus_offsets = arrow::AllocateBuffer(sizeof(int32_t) * (num_strings + 1)).ValueOrDie();
  l_linestatus_values = arrow::AllocateBuffer(num_chars).ValueOrDie();

  sum_qty = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();
  sum_base_price = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();
  sum_disc_price = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();
  sum_charge = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();
  avg_qty = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();
  avg_disc = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();
  avg_price = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();
  count_order = arrow::AllocateBuffer(sizeof(int64_t) * num_rows).ValueOrDie();

  std::shared_ptr<arrow::Schema> schema = arrow::schema({arrow::field("l_returnflag", arrow::utf8(), false),
                                                         arrow::field("l_linestatus", arrow::utf8(), false),
                                                         arrow::field("sum_qty", arrow::float64(), false),
                                                         arrow::field("sum_base_price", arrow::float64(), false),
                                                         arrow::field("sum_disc_price", arrow::float64(), false),
                                                         arrow::field("sum_charge", arrow::float64(), false),
                                                         arrow::field("avg_qty", arrow::float64(), false),
                                                         arrow::field("avg_price", arrow::float64(), false),
                                                         arrow::field("avg_disc", arrow::float64(), false),
                                                         arrow::field("count_order", arrow::int64(), false)});
  auto l_returnflag_arr = std::make_shared<arrow::StringArray>(num_rows, l_returnflag_offsets, l_returnflag_values);
  auto l_linestatus_arr = std::make_shared<arrow::StringArray>(num_rows, l_linestatus_offsets, l_linestatus_values);
  auto sum_qty_arr = std::make_shared<arrow::DoubleArray>(num_rows, sum_qty);
  auto sum_base_price_arr = std::make_shared<arrow::DoubleArray>(num_rows, sum_base_price);
  auto sum_disc_price_arr = std::make_shared<arrow::DoubleArray>(num_rows, sum_disc_price);
  auto sum_charge_arr = std::make_shared<arrow::DoubleArray>(num_rows, sum_charge);
  auto avg_qty_arr = std::make_shared<arrow::DoubleArray>(num_rows, avg_qty);
  auto avg_disc_arr = std::make_shared<arrow::DoubleArray>(num_rows, avg_disc);
  auto avg_price_arr = std::make_shared<arrow::DoubleArray>(num_rows, avg_price);
  auto count_order_arr = std::make_shared<arrow::Int64Array>(num_rows, count_order);
  // Final recordbatch
  std::vector<std::shared_ptr<arrow::Array>> output_arrs = {l_returnflag_arr, l_linestatus_arr, sum_qty_arr, sum_base_price_arr, sum_disc_price_arr, sum_charge_arr, avg_qty_arr, avg_price_arr, avg_disc_arr, count_order_arr};
  auto recordbatch = arrow::RecordBatch::Make(schema, num_rows, output_arrs);
  return recordbatch;
}
#ifdef SV_TEST

//fw decl
int tpch_main(int argc, char **argv);
extern "C" void test_main(uint32_t *exit_code)
{

  printf("tpch.cpp test_main simulation runtime entry point\n");

  char *rb_base = getenv("TEST_RECORDBATCH_BASE");
  if (rb_base)
  {
    //printf("TEST_RECORDBATCH_BASE: %s", rb_base ); //do not try to print this because it is not terminated
  }
  else
  {
    printf("Error: TEST_RECORDBATCH_BASE not found.\n");
    printf("Please set this environment variable to the location (including the path) "
           "of the test recordbatches generated by tpch.py, excluding the number+extension suffix (000.rb).\n");
    printf("For example: `export TEST_RECORDBATCH_BASE=~/workspaces/tpch/gen/rematch`.\n");
    exit_code = 0;
    return;
  }

  char *argv[] = {(char *)"tpch", rb_base, (char *)"1", (char *)"2"};
  if (tpch_main(4, argv) == 0)
  {
    *exit_code = 1;
  }
  else
  {
    *exit_code = 0;
  }
}

int tpch_main(int argc, char **argv)
{

#else  //!SV_TEST

//Entry point for normal operation (not simulating)
int main(int argc, char **argv)
{
#endif //SV_TEST

  int32_t num_strings = 4;
  int32_t num_chars = 1;
  int32_t num_rows = 4;
  printf("\n\ttpch - Regular Expression matcher FPGA circuit generator - runtime\n\n");
  // Check number of arguments.
  if (argc != 4)
  {
    std::cerr << "Incorrect number of arguments. Usage: \n\ttpch <recordbatch_basename> "
              << "<nkernels> <nOutputs> [sim]\n"
              << "The recordbatch_basename will be appended with the number 000 - nKernels, "
              << "so if you have 15 kernels you should have recordbatch_basename000.rb up to "
              << "recordbatch_basename015.rb in your working directory."
              << "nKernels \tThe number of kernels in your hardware design"
              << "nOutputs \tThe number of regular expressions in your hardware design"
              << std::endl;
    return -1;
  }

  int nKernels = (uint32_t)std::strtoul(argv[2], nullptr, 10);

  std::cout << "Reading batches...\n";
  std::vector<std::shared_ptr<arrow::RecordBatch>> batches;
  std::shared_ptr<arrow::RecordBatch> number_batch;
  int nameLen = strnlen(argv[1], MAX_STRBUF_SIZE);
  if (nameLen <= 0)
  {
    std::cerr << "Something is wrong with the recordbatch basename." << std::endl;
    return -1;
  }
  char *nameBuf = (char *)malloc(nameLen + NAME_SUFFIX_LENGTH);
  strncpy(nameBuf, argv[1], nameLen + NAME_SUFFIX_LENGTH);
  nameBuf[nameLen + NAME_SUFFIX_LENGTH] = '\0'; //terminate the string

  // Attempt to read the RecordBatches from the supplied argument.
  for (int i = 0; i < nKernels; i++)
  {
    snprintf(nameBuf + nameLen, MAX_STRBUF_SIZE, "%03d.rb", i);
    fletcher::ReadRecordBatchesFromFile(nameBuf, &batches);
  }
  std::cout << "Batches read...\n";

  // RecordBatch should contain exactly one batch.
  if (batches.size() != (uint32_t)nKernels)
  {
    std::cerr << "Your set of files does not contain enough Arrow RecordBatches (" << batches.size()
              << ") for the specified number of kernels (" << nKernels << ")." << std::endl;
    return -1;
  }

  //Prepare the output recordbatch
  auto output_batch = PrepareRecordBatch(num_strings, 1, num_rows);

  auto res_l_returnflag_array = std::dynamic_pointer_cast<arrow::StringArray>(output_batch->column(0));

  auto res_l_returnflag_off = res_l_returnflag_array->value_offsets()->mutable_data();
  auto res_l_returnflag_val = res_l_returnflag_array->value_data()->mutable_data();
  //auto res_l_returnflag_off_size = res_l_returnflag_array->value_offsets()->size();
  //auto res_l_returnflag_val_size = res_l_returnflag_array->value_data()->size();

  auto res_l_linestatus_array = std::dynamic_pointer_cast<arrow::StringArray>(output_batch->column(1));
  auto res_l_linestatus_off = res_l_linestatus_array->value_offsets()->mutable_data();
  auto res_l_linestatus_val = res_l_linestatus_array->value_data()->mutable_data();
  //auto res_l_linestatus_off_size = res_l_linestatus_array->value_offsets()->size();
  //auto res_l_linestatus_val_size = res_l_linestatus_array->value_data()->size();

  auto res_sum_qty = std::dynamic_pointer_cast<arrow::DoubleArray>(output_batch->column(2));
  auto res_sum_qty_data = res_sum_qty->values()->mutable_data();
  //auto res_sum_qty_size = res_sum_qty->values()->size();

  auto res_sum_base_price = std::dynamic_pointer_cast<arrow::DoubleArray>(output_batch->column(3));
  auto res_sum_base_price_data = res_sum_base_price->values()->mutable_data();
  //auto res_sum_base_price_size = res_sum_base_price->values()->size();

  auto res_sum_disc_price = std::dynamic_pointer_cast<arrow::DoubleArray>(output_batch->column(4));
  auto res_sum_disc_data = res_sum_disc_price->values()->mutable_data();
  //auto res_sum_disc_size = res_sum_disc_price->values()->size();

  auto res_sum_charge = std::dynamic_pointer_cast<arrow::DoubleArray>(output_batch->column(5));
  auto res_sum_charge_data = res_sum_charge->values()->mutable_data();
  //auto res_sum_charge_size = res_sum_charge->values()->size();

  auto res_avg_qty = std::dynamic_pointer_cast<arrow::DoubleArray>(output_batch->column(6));
  auto res_avg_qty_data = res_avg_qty->values()->mutable_data();
  //auto res_avg_qty_size = res_avg_qty->values()->size();

  auto res_avg_price = std::dynamic_pointer_cast<arrow::DoubleArray>(output_batch->column(7));
  auto res_avg_price_data = res_avg_price->values()->mutable_data();
  //auto res_avg_price_size = res_avg_price->values()->size();

  auto res_avg_disc = std::dynamic_pointer_cast<arrow::DoubleArray>(output_batch->column(8));
  auto res_avg_disc_data = res_avg_disc->values()->mutable_data();
  //auto res_avg_disc_size = res_avg_disc->values()->size();

  auto res_count_order = std::dynamic_pointer_cast<arrow::Int64Array>(output_batch->column(9));
  auto res_count_order_data = res_count_order->values()->mutable_data();
  //auto res_count_order_size = res_count_order->values()->size();

  fletcher::Status status;
  std::shared_ptr<fletcher::Platform> platform;
  std::shared_ptr<fletcher::Context> context;

  // Create a Fletcher platform object, attempting to autodetect the platform.
#ifdef SV_TEST
  status = fletcher::Platform::Make("aws_sim", &platform);
#else
  // Create a Fletcher platform object, attempting to autodetect the platform.
  status = fletcher::Platform::Make("aws", &platform);
#endif

  if (!status.ok())
  {
    std::cerr << "Could not create Fletcher platform." << std::endl;
    return -1;
  }

  // Initialize the platform.
#ifdef SV_TEST
  InitOptions options = {1}; //do not initialize DDR for the 1DDR version
  platform->init_data = &options;
#endif
  // Initialize the platform.
  status = platform->Init();

  if (!status.ok())
  {
    std::cerr << "Could not initialize Fletcher platform." << std::endl;
    return -1;
  }

  // Create a context for our application on the platform.
  status = fletcher::Context::Make(&context, platform);

  if (!status.ok())
  {
    std::cerr << "Could not create Fletcher context." << std::endl;
    return -1;
  }

  // Queue the recordbatch to our context.
  status = context->QueueRecordBatch(batches[0]);
  if (!status.ok())
  {
    std::cerr << "Could not queue input batch." << std::endl;
    return -1;
  }
  //Also the outbatch
  status = context->QueueRecordBatch(output_batch);
  if (!status.ok())
  {
    std::cerr << "Could not queue output batch." << std::endl;
    return -1;
  }

  // "Enable" the context, potentially copying the recordbatch to the device. This depends on your platform.
  // AWS EC2 F1 requires a copy, but OpenPOWER SNAP doesn't.
  context->Enable();

  if (!status.ok())
  {
    std::cerr << "Could not enable the context." << std::endl;
    return -1;
  }

  // Create a kernel based on the context.
  fletcher::Kernel kernel(context);
  kernel.SetRange(1, 0, 3);

  // Start the kernel.
  status = kernel.Reset();

  if (!status.ok())
  {
    std::cerr << "Could not start the kernel." << std::endl;
    return -1;
  }

  // Start the kernel.
  status = kernel.Start();

  if (!status.ok())
  {
    std::cerr << "Could not start the kernel." << std::endl;
    return -1;
  }

  // Wait for the kernel to finish.
  status = kernel.WaitForFinish();

  if (!status.ok())
  {
    std::cerr << "Something went wrong waiting for the kernel to finish." << std::endl;
    return -1;
  }
  // Take the data back.
  std::cout << "Kernel done!\n";
  const int device_buffer_offset = 9;
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset).device_address, res_l_returnflag_off, sizeof(int32_t) * (num_strings + 1));
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 1).device_address, res_l_returnflag_val, sizeof(int64_t) * num_chars);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 2).device_address, res_l_linestatus_off, sizeof(int32_t) * (num_strings + 1));
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 3).device_address, res_l_linestatus_val, sizeof(int64_t) * num_chars);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 4).device_address, res_sum_qty_data, sizeof(int64_t) * num_rows);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 5).device_address, res_sum_base_price_data, sizeof(int64_t) * num_rows);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 6).device_address, res_sum_disc_data, sizeof(int64_t) * num_rows);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 7).device_address, res_sum_charge_data, sizeof(int64_t) * num_rows);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 8).device_address, res_avg_qty_data, sizeof(int64_t) * num_rows);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 9).device_address, res_avg_price_data, sizeof(int64_t) * num_rows);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 10).device_address, res_avg_disc_data, sizeof(int64_t) * num_rows);
  platform->CopyDeviceToHost(context->device_buffer(device_buffer_offset + 11).device_address, res_count_order_data, sizeof(int64_t) * num_rows);

  std::cout << "Copy operation is done.\n";
  std::cout << "l_returnflag, l_linestatus, sum_qty, sum_base, sum_disc, sum_charge, avg_qty, avg_price, avg_disc, count_order\n";

  //auto r = res_l_returnflag_array->value_data()->mutable_data();
  //auto l = res_l_linestatus_array->value_data()->mutable_data();
  //const double *q = res_sum_qty->raw_values();
  //const double *b = res_sum_base_price->raw_values();
  //const double *d = res_sum_disc_price->raw_values();
  //const double *c = res_sum_charge->raw_values();
  //const double *aq = res_avg_qty->raw_values();
  //const double *ap = res_avg_price->raw_values();
  //const double *ad = res_avg_disc->raw_values();
  //const int64_t *co = res_count_order->raw_values();
  //for (int i = 0; i < num_rows; ++i)
  //{
  //  std::cout << i << "," << r[i] << "," << l[i] << "," << q[i] << "," << b[i] << "," << d[i] << "," << c[i] << "," << aq[i] << "," << ap[i] << "," << ad[i] << "," << co[i] << "\n";
  //}
  std::cout << res_l_returnflag_array->ToString() << "\n";
  std::cout << res_l_linestatus_array->ToString() << "\n";
  std::cout << res_sum_qty->ToString() << "\n";
  std::cout << res_sum_base_price->ToString() << "\n";
  std::cout << res_sum_disc_price->ToString() << "\n";
  std::cout << res_sum_charge->ToString() << "\n";
  std::cout << res_avg_qty->ToString() << "\n";
  std::cout << res_avg_price->ToString() << "\n";
  std::cout << res_avg_disc->ToString() << "\n";
  std::cout << res_count_order->ToString() << "\n";

  return 0;
}
