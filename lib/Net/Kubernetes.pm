use Net::Kubernetes::Namespace;
use Net::Kubernetes::Role::APIAccess;
use JSON::Fast;

class Net::Kubernetes does Net::Kubernetes::Role::APIAccess {
    has Net::Kubernetes::Namespace $!default_namespace;

    method get_namespace($namespace){
        my $res = $.create_request(:method('GET'), :url($.path() ~ '/namespaces/' ~ $namespace)).run();
        if ($res.success) {
            my %ns = from-json($res.content).pairs;
            say %ns;
            say %ns<metadata><selfLink>;
            return Net::Kubernetes::Namespace.new(:url($.url), :base_path(%ns<metadata><selfLink>), :api_version($.api_version), :namespace($namespace), :username($.username), :password($.password), :token($.token))
        }
    }

    method default_namespace() {
        if (! $!default_namespace.defined) {
            $!default_namespace = $.get_namespace('default');
        }
        return $!default_namespace;
    }
}
