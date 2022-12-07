# S3-MP4SPLIT

A wrapper container for Unifiedorigin mp4split packager tool that pipes output via AWS CLI to write to S3 bucket.

## Usage

Example fragmenting an MP4

```
docker run --rm \
  -e USP_LICENSE_KEY=<LICENSE_KEY> \
  -e AWS_ACCESS_KEY_ID=<AWS ACCESS KEY ID> \
  -e AWS_SECRET_ACCESS_KEY=<AWS SECRET ACCESS KEY> \
  eyevinntechnology/s3-mp4split -o s3://<outputbucket>/file.ismv \
  http://my.site/video-file.mp4
```

Generating a server manifest

```
docker run --rm \
  -e USP_LICENSE_KEY=<LICENSE_KEY> \
  -e AWS_ACCESS_KEY_ID=<AWS ACCESS KEY ID> \
  -e AWS_SECRET_ACCESS_KEY=<AWS SECRET ACCESS KEY> \
  eyevinntechnology/s3-mp4split -o s3://<outputbucket>/manifest.ism \
  http://my.site/video-file.mp4 \
  http://my.site/audio-file.mp4 \
```

By default it will use the `<AWS ACCESS KEY ID>` and `<AWS SECRET ACCESS KEY>` as s3 access keys to mp4split. This can be overridden by providing these as arguments for mp4split, for example:

```
docker run --rm \
  -e USP_LICENSE_KEY=<LICENSE_KEY> \
  -e AWS_ACCESS_KEY_ID=<AWS ACCESS KEY ID> \
  -e AWS_SECRET_ACCESS_KEY=<AWS SECRET ACCESS KEY> \
  eyevinntechnology/s3-mp4split 
  --s3_access_key=<S3 AWS ACCESS KEY ID> \
  --s3_secret_key=<S3 AWS SECRET ACCESS KEY> \
  -o s3://<outputbucket>/manifest.ism \
  http://my.site/video-file.mp4 \
  http://my.site/audio-file.mp4 \
```

## Contributing

If you're interested in contributing to the project:

- We welcome all people who want to contribute in a healthy and constructive manner within our community. To help us create a safe and positive community experience for all, we require all participants to adhere to the [Code of Conduct](CODE_OF_CONDUCT.md).
- If you are looking to make a code change create a Pull Request with suggested changes.
- Develop and contribute with scheduling service plugins.
- Report, triage bugs or suggest enhancements.
- Help others by answering questions.

## License (Apache-2.0)

```
Copyright 2022 Eyevinn Technology AB

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Support

Join our [community on Slack](http://slack.streamingtech.se) where you can post any questions regarding any of our open source projects. Eyevinn's consulting business can also offer you:

- Further development of this component
- Customization and integration of this component into your platform
- Support and maintenance agreement

Contact [sales@eyevinn.se](mailto:sales@eyevinn.se) if you are interested.

## About Eyevinn Technology

[Eyevinn Technology](https://www.eyevinntechnology.se) is an independent consultant firm specialized in video and streaming. Independent in a way that we are not commercially tied to any platform or technology vendor. As our way to innovate and push the industry forward we develop proof-of-concepts and tools. The things we learn and the code we write we share with the industry in [blogs](https://dev.to/video) and by open sourcing the code we have written.

Want to know more about Eyevinn and how it is to work here. Contact us at work@eyevinn.se!