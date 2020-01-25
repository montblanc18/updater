require "mupdater"

RSpec.describe 'test of mupdate' do

    describe 'os_check' do
        example 'if os is macosx is set' do
            if os == :macosx
                t_msg = ["[NOTICE] This platform is macosx.\n", 
                        "[NOTICE] This program supports this OS.\n"].join
                expect { os_check }.to output(t_msg).to_stdout
            else
                puts "This platform is not macosx, and skip this test."
            end
        end 

        example 'if os is linux is set' do
            if os == :linux
                t_msg = ["[NOTICE] This platform is linux.\n", 
                        "[NOTICE] This program supports this OS.\n"].join
                expect { os_check }.to output(t_msg).to_stdout
            else
                puts "This platform is not linux, and skip this test."
            end
        end 
    end

    

end