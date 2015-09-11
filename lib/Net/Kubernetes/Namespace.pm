use Net::Kubernetes::Role::APIAccess;
use Net::Kubernetes::Resource;
use JSON::Fast;
use Net::Kubernetes::Role::ResourceFactory;

class Net::Kubernetes::Namespace does Net::Kubernetes::Role::APIAccess does Net::Kubernetes::Role::ResourceFactory {
    has Str $.namespace;

    method get_pod ($name) {
        say $.path() ~ '/pods/' ~ $name;
        my $res = $.create_request(:method('GET'), :url($.path() ~ '/pods/' ~ $name)).run();
        say $res;
        if ($res.success) {
            my %pod = from-json($res.content).pairs;
            return $.create_resource_object(%pod);
            #return Net::Kubernetes::Resource.new(:url($.url), :base_path(%pod<metadata><selfLink>), :metadata(%pod<metadata>), :api_version($.api_version), :username($.username), :password($.password), :token($.token))
        }
    }
    method list_pods () {
        return $.list_object_by_type(:type('Pod')).list;
    }
    method list_events () {
        return $.list_object_by_type(:type('Event')).list;
    }

    method list_rc () {
        return $.list_object_by_type(:type('ReplicationController')).list;
    }
    Net::Kubernetes::Namespace.^add_method("list_replicationcontrollers", Net::Kubernetes::Namespace.^method_table<list_rc>);
    Net::Kubernetes::Namespace.^compose;

    method list_secrets () {
        return $.list_object_by_type(:type('Secret')).list;
    }

    method list_object_by_type(:$type, :$path? is copy) {
        if ! $path.defined {
            $path = $type.lc ~ 's';
        }
        my $res = $.create_request(:method('GET'), :url($.path() ~ '/' ~ $path)).run();
        say $res;
        if ($res.success) {
            my %objects = from-json($res.content).pairs;
            my @objects = ();
            for @(%objects<items>) -> $item {
                my %object = %($item);
                %object<api_version> = %objects<apiVersion>;
                @objects.push: $.create_resource_object(%object, $type);
            }
            return @objects;
        }
    }
}
