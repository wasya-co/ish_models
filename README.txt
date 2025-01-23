
Wco Models.

== Test ==

Login to the localstack container, then:

  awslocal s3api put-object --bucket wco-email-ses-development \
    --key 00nn652jk1395ujdr3l11ib06jam0oevjqv2o4g1 \
    --body /opt/tmp/00nn652jk1395ujdr3l11ib06jam0oevjqv2o4g1

In ruby console:

  stub = WcoEmail::MessageStub.create({
    object_key: '00nn652jk1395ujdr3l11ib06jam0oevjqv2o4g1',
    bucket: 'wco-email-ses-development',
    config: { process_images: false }.to_json,
  })
  stub.do_process

