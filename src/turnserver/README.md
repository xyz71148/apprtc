- https://meetrix.io/blog/webrtc/turnserver/long_term_cred.html


    secret=mysecret && \
    time=$(date +%s) && \
    expiry=8400 && \
    username=$(( $time + $expiry )) &&\
    echo username:$username && \
    echo password : $(echo -n $username | openssl dgst -binary -sha1 -hmac $secret | openssl base64)
    
    
