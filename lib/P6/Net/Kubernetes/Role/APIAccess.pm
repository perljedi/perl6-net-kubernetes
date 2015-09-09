use JSON::Tiny;
use HTTP::Client;

role P6::Net::Kubernetes::Role::APIAccess {
    has Str $.url is readonly  = 'http://localhost:8080';
    has $.api_version is readonly = 'v1';
    has $.base_path is readonly = '/api/' ~ $!api_version;
    has $.password is readonly;
    has $.username is readonly;
    has $.token is readonly;
    has HTTP::Client $.lwp is readonly = HTTP::Client.new(user-agent=>'net-kubernetes-perl/0.19');;

    method create_request (:$method, :$url, :%headers?, :$content?) {
        my $req = $.lwp.make-request($method);
        $req.url($url);
        if ($.username.defined && $.password.defined) {
            $req.add-header(Authorization=>"Basic " ~ MIME::Base64.encode-str($.username ~ ':' ~ $.password));
        }
        else {
            if ($.token.defined) {
                $req.add-header(Authorization=>"Bearer " ~ $.token);
            }
        }
        return $req;
    }

    method path() {
        return $.url ~ $.base_path;
    }
}
