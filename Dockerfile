FROM alpine:3.9.3 as builder
RUN apk add --update git make tar gcc python gfortran g++ perl
WORKDIR /julia-source
RUN git clone --progress https://github.com/JuliaLang/julia.git .
RUN git checkout f189ae4de8cdfd46908c835858e33cf6765465a4
RUN echo 'override USE_BINARYBUILDER_UNWIND=0' >> Make.user
COPY patches/0001-fix-rpath.diff patches/
RUN patch -i patches/0001-fix-rpath.diff
RUN make -j4 && make binary-dist

FROM alpine:3.9.3
ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH
COPY --from=builder /julia-source/julia*.tar.gz julia.tar.gz
RUN mkdir "$JULIA_PATH" && tar -C "$JULIA_PATH"  --strip-components=1 -xzf julia.tar.gz && rm julia.tar.gz
CMD ["julia"]
