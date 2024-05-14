import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";

using TypeSpec.Http;
using TypeSpec.Rest;

/** This is a pet store service. */
@service({
  title: "Pet Store Service",
})
@server("https://example.com", "The service endpoint")
namespace PetStore;

@route("/pets")
namespace Pets {
  op list(@query skip: int32, @query top: int32): {
    @statusCode statusCode: 200;
    @body pets: Pet[];
  };
  op read(@path petId: int32, @header ifMatch?: string): {
    @statusCode statusCode: 200;
    @header eTag: string;
    @body pet: Pet;
  } | {
    @statusCode statusCode: 404;
  };
  
  @post
  op create(...Pet): {
    @statusCode statusCode: 204;
  };

}

@route("pets/{petId}/toys")
namespace PetToys {
    model Toy {
        name: string;
    }
    op list(@path petId: int32): Toy[];
}

model Pet {
  @minLength(100)
  name: string;

  @minValue(0)
  @maxValue(100)
  age: int32;

  kind: "dog" | "cat" | "fish";
}

model CommonParameters {
    @path
    @segment("tenants")
    tenantId: string;

    @path
    @segment("users")
    userName: string;
}

model User {
    name: string;
}

@error
model Error {
    message: string;
}

@autoRoute
interface UserOperations {
    @get
    getUser(...CommonParameters): User | Error;

    @put
    updateUser(...CommonParameters, user: User): User | Error;

}
