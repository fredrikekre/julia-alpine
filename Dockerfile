FROM alpine:3.11.2 as builder
ARG VERSION
RUN apk add --update git make tar gcc python gfortran g++ perl
WORKDIR /julia-source
RUN git clone --progress https://github.com/JuliaLang/julia.git . && \
    if [[ "$VERSION" ]]; then \
        git checkout $VERSION; \
    fi
COPY patches/ patches/
RUN ./patches/apply-patches.sh $VERSION
RUN make \
    JULIA_COMMIT=$(echo $VERSION | cut -c 2-) \
    MARCH="x86-64" \
    JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)" \
    -j4 \
    binary-dist

FROM alpine:3.11.2
ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH
COPY --from=builder /julia-source/julia*.tar.gz julia.tar.gz
RUN mkdir "$JULIA_PATH" && tar -C "$JULIA_PATH"  --strip-components=1 -xzf julia.tar.gz && rm julia.tar.gz
CMD ["julia"]
