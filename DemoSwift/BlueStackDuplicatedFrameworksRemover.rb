
def remove_duplicated_frameworks(app_pod_name, installer)
    test_targets = get_test_targets(app_pod_name, installer)
    libraryTargets = [
           'FBAudienceNetwork',
           'CriteoPublisherSdk',
           'OgurySdk',
           'OguryCore',
           'OguryChoiceManager',
           'OguryAds',
           'GoogleMobileAds',
           'UserMessagingPlatform',
           'GoogleUtilities',
           'GoogleDataTransport',
           'GoogleAppMeasurement',
           'GoogleAppMeasurementIdentitySupport'
       ]

    targets = installer.aggregate_targets.select { |x| !test_targets.include?(x.name) }

    # Checks each pair of targets if they have common pods. Duplicates are removed from the first one's xcconfig.
    for i in 0..targets.size-1 do
        target = targets[i]
        remainingAppPodTargets = targets[i..targets.size-1].flat_map(&:pod_targets)

        target.xcconfigs.each do |config_name, config_file|
            # Removes all frameworks which exist in other pods
            
            remainingAppPodTargets
                .flat_map { |pod_target| get_framework_names(pod_target)
                 get_framework_names(pod_target).each { |framework|
                 if libraryTargets.include? framework
                   config_file.frameworks.delete(framework)
                end

                  }

                }
            # Saves updated xcconfig
            xcconfig_path = target.xcconfig_path(config_name)
            config_file.save_as(xcconfig_path)
        end
    end
end

def get_test_targets(app_pod_name, installer)
    main_target_name = app_pod_name.gsub("Pods-", "")

    installer.aggregate_targets
        .find { |x| x.name == app_pod_name }
        .user_project
        .targets
        .select { |x| x.test_target_type? }
        .flat_map { |x| ["Pods-#{x}", "Pods-#{main_target_name}-#{x}"] }
        .select { |x| installer.aggregate_targets.map(&:name).include?(x) }
        .uniq
end

def get_framework_names(pod_target)

    frameworkNames = pod_target.specs.flat_map do |spec|
        # We should take framework names from 'vendored_frameworks'.
        # If it's not defined, we use 'spec.name' instead.
        #
        # spec.name can be defined like Framework/Something - we take the first part
        # because that's what appears in OTHER_LDFLAGS.
        frameworkPaths = unless spec.attributes_hash['ios'].nil?
            then spec.attributes_hash['ios']['vendored_frameworks']
            else spec.attributes_hash['vendored_frameworks']
            end || [spec.name.split(/\//, 2).first]

        map_paths_to_filenames(frameworkPaths)
    end

    frameworkNames.uniq
end

def map_paths_to_filenames(paths)
    Array(paths).map(&:to_s).map do |filename|
        extension = File.extname filename
        File.basename filename, extension
    end
end
