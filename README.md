# Fluentd output plugin for vertica # 

Fluentd output plugin for vertica based using the JSON parser.
Please see [Fluentd](http://fluentd.org) for more information

## Example configuration ##

    <match vertica.public.test>
      type verticajson

      database mydb
      schema public
      table test

      username dbadmin
      password mypass

      host 127.0.0.1
      port 5433
    </match>