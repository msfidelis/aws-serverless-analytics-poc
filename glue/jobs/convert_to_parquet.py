import sys
from pyspark.context import SparkContext
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.transforms import *
from awsglue.job import Job
from datetime import datetime

args = getResolvedOptions(sys.argv, [
	'JOB_NAME',
	'source_bucket',
	'lake_bucket',
	'number_of_partitions'
])

glueContext = GlueContext(SparkContext.getOrCreate())
spark = glueContext.spark_session

# Set Folder Key
key = datetime.now().strftime("%Y-%m-%d")

job = Job(glueContext)
job.init(args['JOB_NAME'], args)

inputPath 	= 's3://' + args['source_bucket'] + '/' + key  + '/'
outputPath 	= 's3://' + args['lake_bucket']  + '/' + key  + '/'

numberOfPartitions = int(args.get('number_of_partitions', 1))

# Read Data form Source S3
input_dyf = glueContext.create_dynamic_frame_from_options(
	format_options={"multiline": True},
	connection_type="s3",
	format="json",
	connection_options={
		"paths": [ inputPath ],
		"recurse": True
	}
)

# Convert JSON to Parquet Data
repartitionedDYF = input_dyf.repartition(numberOfPartitions)

glueContext.write_dynamic_frame.from_options(
	frame = repartitionedDYF,
	connection_type = "s3",
	connection_options = {"path": outputPath},
	format = "glueparquet"
)

job.commit()