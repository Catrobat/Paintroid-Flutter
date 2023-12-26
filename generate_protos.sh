cd packages/io_library/lib/src/serialization/proto || exit
mkdir -p output
protoc --dart_out=output --proto_path=schema $(find schema -iname "*.proto") google/protobuf/any.proto
