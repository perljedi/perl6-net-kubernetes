use P6::Net::Kubernetes::Namespace;
use P6::Net::Kubernetes::Role::APIAccess;
use JSON::Tiny;

class P6::Net::Kubernetes does P6::Net::Kubernetes::Role::APIAccess {
    has P6::Net::Kubernetes::Namespace $!default_namespace;

    method get_namespace($namespace){
        my $res = $.create_request(:method('GET'), :url($.path() ~ '/namespaces/' ~ $namespace)).run();
        if ($res.success) {
            my %ns = from-json($res.content).pairs;
            return P6::Net::Kubernetes::Namespace.new(:url($.url), :bash_path(%ns<metdata><selfLink>), :api_version($.api_version), :namespace($namespace), :username($.username), :password($.password), :token($.token))
        }
    }

    method default_namespace() {
        if (! $!default_namespace.defined) {
            $!default_namespace = $.get_namespace('default');
        }
        return $!default_namespace;
    }
}
