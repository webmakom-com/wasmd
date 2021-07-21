package keeper

import (
	"encoding/json"
	"fmt"
	"github.com/stretchr/testify/require"
	"testing"

	wasmvmtypes "github.com/CosmWasm/wasmvm/types"
)

func TestTfiFactoryInstantiate(t *testing.T) {
	cosmosMsg := []byte("{\"id\":1,\"msg\":{\"wasm\":{\"instantiate\":{\"admin\":null,\"code_id\":3,\"msg\":\"eyJhc3NldF9pbmZvcyI6W3sibmF0aXZlIjoidXRnZCJ9LHsidG9rZW4iOiJ0Z3JhZGUxcGc2MDZqdzY4ZDltbmg5Y3pyZ203Y2VsYzNycTl4NXd3Z3FxeTAifV0sInRva2VuX2NvZGVfaWQiOjR9\",\"send\":[],\"label\":\"utgd-tgrade1pg606jw68d9mnh9czrgm7celc3rq9x5wwgqqy0\"}}},\"gas_limit\":null,\"reply_on\":\"success\"}")
	subMsg := wasmvmtypes.SubMsg{}
	err := json.Unmarshal(cosmosMsg, &subMsg)
	require.NoError(t, err)

	fmt.Printf("%#v\n", subMsg)
	msg := subMsg.Msg
	fmt.Printf("%#v\n", msg)
	require.NotNil(t, msg.Wasm)

	sender := RandomAccountAddress(t)
	sdkMsgs, err := EncodeWasmMsg(sender, msg.Wasm)
	require.NoError(t, err)
	require.Equal(t, 1, len(sdkMsgs))
	sdkMsg := sdkMsgs[0]
	fmt.Printf("%#v\n", sdkMsg)

	err = sdkMsg.ValidateBasic()
	require.NoError(t, err)
}