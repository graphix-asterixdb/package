#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM amazonlinux
ARG graphix_release=0.4.1

# Setup Graphix...
RUN yum -y update
RUN yum install -y unzip java-11-amazon-corretto-headless wget python3-pip which
RUN wget https://github.com/graphix-asterixdb/package/releases/download/alpha-$graphix_release/graphix-$graphix_release-alpha.zip
RUN mkdir /asterixdb
RUN unzip graphix-$graphix_release-alpha.zip -d /asterixdb
RUN rm graphix-$graphix_release-alpha.zip
RUN mv /asterixdb/graphix-$graphix_release-alpha/* /asterixdb

# ...and supervisor...
COPY supervisord.conf /etc/supervisord.conf
RUN pip3 install supervisor

# ...and run Graphix!
ENV JAVA_OPTS -Xmx1536m
EXPOSE 8888 19001 19002 19003 19006 50031
ENTRYPOINT ["/bin/bash", "-c", "supervisord"]