require 'spec_helper'

describe Guard::MochaNode::Runner do
  let(:runner) { Guard::MochaNode::Runner }

  before do
    Open3.stub(:popen3 => "response")
  end

  describe ".run" do
    let(:options) { { :paths_for_all_specs => %w(spec)} }
    context "when passed no paths" do
      it "returns false" do
        runner.run.should be_false
      end
    end

    context "when passed paths" do
      let(:some_paths) { %w(/foo/bar /zip/zap) }

      it "executes mocha node" do
        Open3.should_receive(:popen3) do |*args|
	  args[0].should eq "__EXECUTABLE__"
	end
        runner.run(some_paths, options.merge({ :mocha_bin => "__EXECUTABLE__"}))
      end

      it "passes the paths to the executable" do
        Open3.should_receive(:popen3) do |*args|
	  last_args = args[(some_paths.length * -1)..(-1)]
	  last_args.should eql some_paths
	end
        runner.run(some_paths, options)
      end

      context "and coffeescript option is true" do
        it "passes the --compilers coffee:coffee-script option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    index_compilers = args.find_index "--compilers"
	    index_compilers.should_not be nil
	    args[index_compilers +1].should eql "coffee:coffee-script"
	  end
	  runner.run(some_paths, options.merge({ :coffeescript => true}))
        end
      end

      context "and coffeescript option is false" do
        it "does not pass the --compilers coffee:coffee-script option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    index_compilers = args.find_index "--compilers"
	    if index_compilers != nil
	      args[index_compilers +1].should_not match /coffee:coffee-script/
	    end
	  end
          runner.run(some_paths, options.merge({ :coffeescript => false}))
        end
      end

      context "and livescript option is true" do
        it "passes the --compilers ls:LiveScript option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    index_compilers = args.find_index "--compilers"
	    index_compilers.should_not be nil
	    args[index_compilers +1].should eql "ls:LiveScript"
	  end
	  runner.run(some_paths, options.merge({ :livescript => true}))
        end
      end

      context "and livescript option is false" do
        it "does not pass the --compilers ls:LiveScript option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    index_compilers = args.find_index "--compilers"
	    if index_compilers != nil
	      args[index_compilers +1].should_not match /ls:LiveScript/
	    end
	  end
          runner.run(some_paths, options.merge({ :livescript => false}))
        end
      end

      context "and both coffeescript and livescript  option are true" do
        it "passes the --compilers coffee:coffee-script,ls:LiveScript option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    index_compilers = args.find_index "--compilers"
	    index_compilers.should_not be nil
	    args[index_compilers +1].should eql "coffee:coffee-script,ls:LiveScript"
	  end
	  runner.run(some_paths, options.merge({ :livescript => true, :coffeescript => true }))
        end
      end

      context "and color option is true" do
        it "passes the -c option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    args.should include "-c"
	  end
          runner.run(some_paths, options.merge({ :color => true}))
        end
      end

      context "and color option is false" do
        it "passes the -C option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    args.should include "-C"
	  end
          runner.run(some_paths, options.merge({ :color => false}))
        end
      end

      context "and recursive option is true" do
        it "passes the --recursive option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    args.should include "--recursive"
	  end
          runner.run(some_paths, options.merge({ :recursive => true}))
        end
      end

      context "and recursive option is false" do
        it "does not pass the --recursive option to mocha node" do
          Open3.should_receive(:popen3) do |*args|
	    args.should_not include "--recursive"
	  end
          runner.run(some_paths, options.merge({ :recursive => false}))
        end
      end

      it "returns IO object" do
        io_obj = double("io obj")
        Open3.stub(:popen3 => io_obj)
        runner.run(some_paths, options).should eql io_obj
      end

      context "when message option is given" do
        it "outputs message" do
          Guard::UI.should_receive(:info).with("hello", anything)
          runner.run(some_paths, options.merge({ :message => "hello"}))
        end
      end

      context "when no message option is given" do
        context "and running all specs" do
          it "outputs message confirming all specs are being run" do
            Guard::UI.should_receive(:info).with("Running all specs", anything)
            runner.run(%w(spec),  options )
          end
        end

        context "and running some specs" do
          it "outputs paths of specs being run" do
            Guard::UI.should_receive(:info).with("Running: /foo/bar /zip/zap", anything)
            runner.run(some_paths, options)
          end
        end
      end
    end
  end
end
