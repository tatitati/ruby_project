require "domain/model/order_stream"
require "infrastructure/domain/user_store/webapi_users_mapper"

describe "WebapiUsersMapper" do
    context "Given JSON Response with list of Users" do
        it "It can create multiple users with empty order stream" do
            domainModels = WebapiUsersMapper.toDomainModel(getGivenUsersResponseJson(), {})

            expect(domainModels.length).to eql(2)
            expect(domainModels).to all(be_an(User))

            expect(domainModels.first.countOrders).to eql(0)
            expect(domainModels.last.countOrders).to eql(0)
        end

        it "It can create multiple users with order stream populated" do
            purchasesGroupedByUser = {"KZHR-1H35-2IH8-JXYN" => OrderStreamBuilder.new.withAmountOfOrders(3).build}
            domainModels = WebapiUsersMapper.toDomainModel(getGivenUsersResponseJson(), purchasesGroupedByUser)

            expect(domainModels).to all(be_an(User))

            expect(domainModels.first.countOrders).to eql(3)
            expect(domainModels.last.countOrders).to eql(0)
        end
    end
end

def getGivenUsersResponseJson()
    givenUsersResponseJson = '{
        "data": [
            {
                "email": "schimmel_quincy@ernser.io",
                "first_name": "Quincy",
                "id": "KZHR-1H35-2IH8-JXYN",
                "last_name": "Schimmel",
                "phone": "186.301.6921 x948"
            },
            {
                "email": "terry_henry@doyle.io",
                "first_name": "Henry",
                "id": "S27G-8UMJ-LDSL-UOPN",
                "last_name": "Terry",
                "phone": "636-387-6074 x690"
            }
        ]
    }';

    givenUsersResponseJson
end